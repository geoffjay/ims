public class Ims.PipelineManager : GLib.Object {

    private Peas.ExtensionSet pipeline_extensions;
    private string[] search_paths = { Ims.PLUGINDIR };

    private Ims.Pipeline pipeline;
    private Ims.PipelineAddin pipeline_extension;

    public signal void plugin_available (string name);

    public PipelineManager (Ims.Pipeline pipeline) {
        this.pipeline = pipeline;
        //pipeline_extension = new Ims.PipelineAddin (pipeline);

        add_pipeline_extension ();

        /*
         *pipeline_extensions.@foreach ((@set, info, exten) => {
         *    @set.extension_added (info, exten);
         *});
         */
    }

    private void add_pipeline_extension () {
        pipeline_extensions = new Peas.ExtensionSet (Peas.Engine.get_default (),
                                                     typeof (Peas.Activatable),
                                                     "object",
                                                     this);

        /*
         *pipeline_extensions = new Peas.ExtensionSet (Peas.Engine.get_default (),
         *                                             typeof (Ims.PipelineAddin)
         *                                             "pipeline",
         *                                             pipeline);
         */

        pipeline_extensions.extension_added.connect (extension_added_cb);
        pipeline_extensions.extension_removed.connect (extension_removed_cb);
    }

    private void extension_added_cb (Peas.PluginInfo info, GLib.Object exten) {
        /* TODO handle extension setup during addition */
        debug ("%s pipeline component was added", info.get_name ());
        (exten as Peas.Activatable).activate ();
        // (exten as Ims.PipelineAddin).load (pipeline);
    }

    private void extension_removed_cb (Peas.PluginInfo info, GLib.Object exten) {
        /* TODO handle extension clean up after removal */
        debug ("%s pipeline component was removed", info.get_name ());
        (exten as Peas.Activatable).deactivate ();
        // (exten as Ims.PipelineAddin).unload (pipeline);
    }

/*
 *    public void enable_plugin (string plugin) throws GLib.Error {
 *        var info = engine.get_plugin_info (plugin);
 *        if (info == null) {
 *            throw new Ims.PluginError.NOT_FOUND (
 *                "Cannot enable %s, not found", plugin);
 *        }
 *
 *        debug ("FIXME: this should be a plugin, not an extension");
 *        var extension = pipeline_extensions.get_extension (info);
 *        (extension as Peas.Activatable).activate ();
 *    }
 */

/*
 *    public void disable_plugin (string plugin) throws GLib.Error {
 *        var info = engine.get_plugin_info (plugin);
 *        if (info == null) {
 *            throw new Ims.PluginError.NOT_FOUND (
 *                "Cannot disable %s, not found", plugin);
 *        }
 *
 *        debug ("FIXME: this should be a plugin, not an extension");
 *        var extension = pipeline_extensions.get_extension (info);
 *        (extension as Peas.Activatable).deactivate ();
 *    }
 */
}
