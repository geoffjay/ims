[ModuleInit]
public void peas_register_types (GLib.TypeModule module) {
    var peas = module as Peas.ObjectModule;

    peas.register_extension_type (typeof (Ims.PipelineAddin), typeof (Ims.PipelineSaveAddin));
}
