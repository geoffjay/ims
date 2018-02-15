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

G_BEGIN_DECLS

#define IMS_TYPE_PIPELINE_ADDIN (ims_pipeline_addin_get_type())

G_DECLARE_INTERFACE (ImsPipelineAddin, ims_pipeline_addin, IMS, PIPELINE_ADDIN, GObject)

struct _ImsPipelineAddinInterface
{
    GTypeInterface parent;

    void    (*load)     (ImsPipelineAddin     *self,
                         ImsPipeline          *pipeline);
    void    (*unload)   (ImsPipelineAddin     *self,
                         ImsPipeline          *pipeline);
};

void ims_pipeline_addin_load    (ImsPipelineAddin     *self,
                                 ImsPipeline          *pipeline);

void ims_pipeline_addin_unload  (ImsPipelineAddin     *self,
                                 ImsPipeline          *pipeline);

G_END_DECLS
