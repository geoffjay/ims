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

#define G_LOG_DOMAIN "ims-router-addin"

#include "ims.h"
#include "ims-enums.h"
/*#include "ims-router-addin.h"*/

G_DEFINE_INTERFACE (ImsRouterAddin, ims_element_provider, G_TYPE_OBJECT)

static void
ims_router_addin_real_load (ImsRouterAddin *self)
{
}

static void
ims_router_addin_real_unload (ImsRouterAddin *self)
{
}

static void
ims_router_addin_default_init (ImsRouterAddinInterface *iface)
{
    iface->load = ims_router_addin_real_load;
    iface->unload = ims_router_addin_real_unload;
}

void ims_router_addin_load (ImsRouterAddin *self,
                            ImsRouter      *router)
{
    g_return_if_fail (IMS_IS_ROUTER_ADDIN (self));
    g_return_if_fail (IMS_IS_ROUTER (router));

    IMS_ROUTER_ADDIN_GET_IFACE (self)->load (self, router);
}

void ims_router_addin_unload (ImsRouterAddin *self,
                              ImsRouter      *router)
{
    g_return_if_fail (IMS_IS_ROUTER_ADDIN (self));
    g_return_if_fail (IMS_IS_ROUTER (router));

    IMS_ROUTER_ADDIN_GET_IFACE (self)->unload (self, router);
}
