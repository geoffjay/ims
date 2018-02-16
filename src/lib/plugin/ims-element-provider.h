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

#pragma once

#include <glib-object.h>

#include "ims.h"

G_BEGIN_DECLS

typedef enum {
    IMS_ELEMENT_READY = 1 << 0,
    IMS_ELEMENT_RUNNING = 1 << 1,
    IMS_ELEMENT_STOPPED = 1 << 2,
    IMS_ELEMENT_PAUSED = 1 << 3,
    IMS_ELEMENT_FAILED = 1 << 4
} ImsElementState;

#define IMS_TYPE_ELEMENT_PROVIDER (ims_element_provider_get_type())

G_DECLARE_INTERFACE (ImsElementProvider, ims_element_provider, IMS, ELEMENT_PROVIDER, GObject)

struct _ImsElementProviderInterface
{
    GTypeInterface parent;

    ImsElement *    (*get_element)     (ImsElementProvider *self);
};

ImsElement *ims_element_provider_get_element (ImsElementProvider *self);

G_END_DECLS
