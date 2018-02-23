public class Ims.PipelineController : GLib.Object {

    private Peas.ExtensionSet pipeline_extensions;

    private Gee.Map<string, Ims.Pipeline> pipelines;

    public PipelineController () {
        var engine = Peas.Engine.get_default ();

        pipelines = new Gee.HashMap<string, Ims.Pipeline> ();

        /*
         *pipeline_extensions = new Peas.ExtensionSet (engine,
         *                                             typeof (Ims.PipelineAddin),
         *                                             "pipeline_controller",
         *                                             this);
         */

        pipeline_extensions = new Peas.ExtensionSet (engine, typeof (Ims.Plugin));

        pipeline_extensions.extension_added.connect (extension_added_cb);
        pipeline_extensions.extension_removed.connect (extension_removed_cb);

        //pipeline_extensions.@foreach ((@set, info, exten) => {
            //@set.extension_added (info, exten);
        //});

        engine.load_plugin.connect_after ((info) => {
            Peas.Extension? exten = pipeline_extensions.get_extension (info);
            if (exten == null) {
                critical ("Failed to find extension for: %s", info.get_name ());
                return;
            }
            //on_extension_added (info, exten);
        });
    }

    private void extension_added_cb (Peas.PluginInfo info, GLib.Object exten) {
        /* TODO handle extension setup during addition */
        debug ("%s pipeline component was added", info.get_name ());
        (exten as Ims.Plugin).load ();
    }

    private void extension_removed_cb (Peas.PluginInfo info, GLib.Object exten) {
        /* TODO handle extension clean up after removal */
        debug ("%s pipeline component was removed", info.get_name ());
        (exten as Ims.Plugin).unload ();
    }

    public void load_pipeline_addin (Peas.PluginInfo info) throws GLib.Error {
        debug ("Load pipeline addin: %s", info.get_name ());
        var extension = pipeline_extensions.get_extension (info);
        //(extension as Ims.PipelineAddin).load (this);
        (extension as Ims.Plugin).load ();
    }

    public void unload_pipeline_addin (Peas.PluginInfo info) throws GLib.Error {
        debug ("Unload pipeline addin: %s", info.get_name ());
        var extension = pipeline_extensions.get_extension (info);
        //(extension as Ims.PipelineAddin).unload (this);
        (extension as Ims.Plugin).unload ();
    }

    public string add_pipeline () {
        var uuid = GLib.Uuid.string_random ();
        debug ("Added a new pipeline with UUID: %s", uuid);
        pipelines.@set (uuid, new Ims.Pipeline ());

        return uuid;
    }

    /* TODO: Check if pipeline is executing before dropping it */
    public void set_pipeline (string uuid, Ims.Pipeline pipeline) throws GLib.Error {
        if (!pipelines.has_key (uuid)) {
            throw new Ims.Error.PIPELINE_AVAILABLE (
                "Pipeline with UUID %s doesn't exist", uuid
            );
        }

        pipelines.unset (uuid);
        pipelines.@set (uuid, pipeline);
    }

    public Ims.Pipeline get_pipeline (string uuid) {
        if (!pipelines.has_key (uuid)) {
            throw new Ims.Error.PIPELINE_AVAILABLE (
                "Pipeline with UUID %s doesn't exist", uuid
            );
        }

        return pipelines.@get (uuid);
    }
}
