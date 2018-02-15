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

#define G_LOG_DOMAIN "ims-pipeline-addin"

#include "ims.h"
#include "ims-enums.h"
/*#include "ims-pipeline-addin.h"*/

G_DEFINE_INTERFACE (ImsPipelineAddin, ims_element_provider, G_TYPE_OBJECT)

static void
ims_pipeline_addin_real_load (ImsPipelineAddin *self)
{
}

static void
ims_pipeline_addin_real_unload (ImsPipelineAddin *self)
{
}

static void
ims_pipeline_addin_default_init (ImsPipelineAddinInterface *iface)
{
    iface->load = ims_pipeline_addin_real_load;
    iface->unload = ims_pipeline_addin_real_unload;
}

void ims_pipeline_addin_load (ImsPipelineAddin *self,
                              ImsPipeline      *pipeline)
{
    g_return_if_fail (IMS_IS_PIPELINE_ADDIN (self));
    g_return_if_fail (IMS_IS_PIPELINE (pipeline));

    IMS_PIPELINE_ADDIN_GET_IFACE (self)->load (self, pipeline);
}

void ims_pipeline_addin_unload (ImsPipelineAddin *self,
                                ImsPipeline      *pipeline)
{
    g_return_if_fail (IMS_IS_PIPELINE_ADDIN (self));
    g_return_if_fail (IMS_IS_PIPELINE (pipeline));

    IMS_PIPELINE_ADDIN_GET_IFACE (self)->unload (self, pipeline);
}
