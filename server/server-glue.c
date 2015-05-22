#ifdef HAVE_LINUX

#include <glib.h>
#include <selinux/selinux.h>

void
frida_server_configure_selinux (GError ** error)
{
  if (setcon ("system_server") == 0)
  {
    g_print ("early setcon succeeded!\n");
  }
  else
  {
    g_print ("early setcon failed!\n");
  }
}

#endif
