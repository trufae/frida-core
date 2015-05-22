#include "frida-core.h"

#include <selinux/selinux.h>

void
frida_helper_factory_configure_exec_context (const gchar * path, GError ** error)
{
  char * con;

  if (!is_selinux_enabled ())
    return;

  if (getcon (&con) == 0)
  {
    g_print ("woop! con='%s'\n", con);
    if (setfilecon (path, "u:object_r:system_file:s0") == 0)
    {
      g_print ("set system file con successfully!!\n");
    }
    else
    {
      g_print ("could not set system file con!\n");
    }
    freecon (con);
  }
}
