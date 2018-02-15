/*
 * This file is part of Ims.
 *
 * Copyright © 2018 Geoff Johnson
 *
 * Ims is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Ims is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Ims.  If not, see <http://www.gnu.org/licenses/>.
 */

#define G_LOG_DOMAIN "ims-plugin"

#include "ims-plugin.h"

G_DEFINE_INTERFACE (ImsPlugin, ims_plugin, G_TYPE_OBJECT)

static void
ims_plugin_real_load (ImsPlugin *self)
{
}

static void
ims_plugin_real_unload (ImsPlugin *self)
{
}

static void
ims_plugin_default_init (ImsPluginInterface *iface)
{
    iface->load = ims_plugin_real_load;
    iface->unload = ims_plugin_real_unload;
}

void ims_plugin_load (ImsPlugin *self)
{
    g_return_if_fail (IMS_IS_PLUGIN (self));

    IMS_PLUGIN_GET_IFACE (self)->load (self);
}

void ims_plugin_unload (ImsPlugin *self)
{
    g_return_if_fail (IMS_IS_PLUGIN (self));

    IMS_PLUGIN_GET_IFACE (self)->unload (self);
}
