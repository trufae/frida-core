#if LINUX
namespace Frida {
	public int main (string[] args) {
		var app = new HelperApplication ();
		return app.run ();
	}

	public class HelperApplication : Object {
		private MainLoop loop = new MainLoop ();
		private int run_result = 0;

		private DBusConnection connection;
		private uint registration_id = 0;

		private HelperService service = new HelperService ();

		public int run () {
			Idle.add (() => {
				start.begin ();
				return false;
			});

			loop.run ();

			return run_result;
		}

		private async void start () {
			try {
				var stream = new SimpleIOStream (new UnixInputStream (0, false), new UnixOutputStream (1, false));
				connection = yield DBusConnection.new (stream, null, DBusConnectionFlags.DELAY_MESSAGE_PROCESSING);
				connection.closed.connect (on_connection_closed);
				service.stopped.connect (on_service_stopped);
				Helper helper = service;
				registration_id = connection.register_object (Frida.ObjectPath.HELPER, helper);
				connection.start_message_processing ();
			} catch (GLib.Error e) {
				printerr ("Unable to start: %s\n", e.message);
				run_result = 1;
				stop.begin ();
			}
		}

		private async void stop () {
			service.stopped.disconnect (on_service_stopped);
			service.reset ();

			if (connection != null) {
				if (registration_id != 0)
					connection.unregister_object (registration_id);
				connection.closed.disconnect (on_connection_closed);
				try {
					yield connection.close ();
				} catch (GLib.Error connection_error) {
				}
				connection = null;
			}

			loop.quit ();
		}

		private void on_connection_closed (bool remote_peer_vanished, GLib.Error? error) {
			stop.begin ();
		}

		private void on_service_stopped () {
			stop.begin ();
		}
	}
}
#endif
