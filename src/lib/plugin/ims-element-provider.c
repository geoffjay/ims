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

#define G_LOG_DOMAIN "ims-element-provider"

#include "ims-enums.h"
/*#include "ims-element-provider.h"*/

G_DEFINE_INTERFACE (ImsElementProvider, ims_element_provider, G_TYPE_OBJECT)

static ImsElement *
ims_element_provider_real_get_element (ImsElementProvider *self)
{
    return NULL;
}

static void
ims_element_provider_default_init (ImsElementProviderInterface *iface)
{
    iface->get_element = ims_element_provider_real_get_element;
}

ImsElement *ims_element_provider_get_element (ImsElementProvider *self)
{
    g_return_val_if_fail (!self, NULL);
    g_return_val_if_fail (IMS_IS_ELEMENT_PROVIDER, NULL);

    return IMS_ELEMENT_PROVIDER_GET_IFACE (self)->get_element (self);
}
