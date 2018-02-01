#ifndef CONFIG_H_INCLUDED
#include "config.h"

/**
 * All this is to keep Vala happy & configured..
 */
const char *IMS_DATADIR = DATADIR;
const char *IMS_CONFDIR = SYSCONFDIR;
const char *IMS_PLUGINDIR = PLUGINDIR;
const char *IMS_VERSION = PACKAGE_VERSION;
const char *IMS_WEBSITE = PACKAGE_URL;
const char *IMS_GETTEXT_PACKAGE = GETTEXT_PACKAGE;

#else
#error config.h missing!
#endif
