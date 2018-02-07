public class Ims.PipelineSaveAddin : GLib.Object, Ims.PipelineAddin {

    public Ims.PipelineManager pipeline_manager { get; construct set; }

    public void load (Ims.PipelineManager pipeline_manager) {
        debug ("Load save addin");
    }

    public void unload (Ims.PipelineManager pipeline_manager) {
        debug ("Unload save addin");
    }
}
