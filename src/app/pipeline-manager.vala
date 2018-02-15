public class Ims.PipelineManager : GLib.Object {

    private Peas.ExtensionSet pipeline_extensions;

    //private Ims.PipelineAddinProxy proxy;

    public Ims.Pipeline pipeline { get; construct set; }

    public PipelineManager (Ims.Pipeline pipeline) {
        this.pipeline = pipeline;
        var engine = Peas.Engine.get_default ();

        /*
         *pipeline_extensions = new Peas.ExtensionSet (engine,
         *                                             typeof (Ims.PipelineAddin),
         *                                             "pipeline_manager",
         *                                             this);
         */

        /*
         * //proxy = new Ims.PipelineAddinProxy (this);
         *pipeline_extensions = new Peas.ExtensionSet (engine,
         *                                             typeof (Peas.Activatable));//,
         *                                             //"object",
         *                                             //proxy,
         *                                             //null);
         */

        pipeline_extensions = new Peas.ExtensionSet (engine, typeof (Ims.Plugin));
        //pipeline_extensions = new Peas.ExtensionSet (engine, typeof (Peas.Activatable));

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
        //(exten as Peas.Activatable).activate ();
        (exten as Ims.Plugin).load ();
    }

    private void extension_removed_cb (Peas.PluginInfo info, GLib.Object exten) {
        /* TODO handle extension clean up after removal */
        debug ("%s pipeline component was removed", info.get_name ());
        //(exten as Peas.Activatable).deactivate ();
        (exten as Ims.Plugin).unload ();
    }

    public void load_pipeline_addin (Peas.PluginInfo info) throws GLib.Error {
        debug ("Load pipeline addin: %s", info.get_name ());
        //var extension = pipeline_extensions.get_extension (info);
        //(extension as Ims.PipelineAddin).load (this);
    }

    public void unload_pipeline_addin (Peas.PluginInfo info) throws GLib.Error {
        debug ("Unload pipeline addin: %s", info.get_name ());
        //var extension = pipeline_extensions.get_extension (info);
        //(extension as Ims.PipelineAddin).unload (this);
    }
}
