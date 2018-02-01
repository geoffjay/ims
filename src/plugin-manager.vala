public errordomain Ims.PluginError {
    NOT_FOUND
}

public class Ims.PluginManager : GLib.Object {

    private Peas.Engine engine;
    private Peas.ExtensionSet pipeline_extensions;
    private Peas.ExtensionSet router_extensions;
    private string[] search_paths = { Ims.PLUGINDIR };

    private Ims.Pipeline pipeline;
    private Ims.Router router;

    public signal void plugin_available (string name);

    public PluginManager () {
        engine = Peas.Engine.get_default ();

        var app = Ims.App.get_default ();
        pipeline = app.get_pipeline ();
        router = app.get_router ();

        init ();
        load ();
    }

    private void init () {
        GLib.Environment.set_variable ("PEAS_ALLOW_ALL_LOADERS", "1", true);
        engine.enable_loader ("python3");

        foreach (var path in search_paths) {
            debug ("Loading plugins from %s", path);
            engine.add_search_path (path, null);
        }

        add_pipeline_extension ();
        add_router_extension ();
    }

    private void load () {
        foreach (var plugin in engine.get_plugin_list ()) {
            if (engine.try_load_plugin (plugin)) {
                debug (plugin.get_name () + " loaded by the plugin manager");
            }
        }
    }

    private void add_pipeline_extension () {
        pipeline_extensions = new Peas.ExtensionSet (engine,
                                                     typeof (Ims.PipelineAddin),
                                                     "pipeline",
                                                     pipeline);

        pipeline_extensions.extension_added.connect ((info, extension) => {
            /* TODO handle extension setup during addition */
            debug ("%s pipeline component was added", info.get_name ());
        });

        pipeline_extensions.extension_removed.connect ((info, extension) => {
            /* TODO handle extension clean up after removal */
            debug ("%s pipeline component was removed", info.get_name ());
        });
    }

    private void add_router_extension () {
        router_extensions = new Peas.ExtensionSet (engine, typeof (Ims.RouterAddin));

        router_extensions.extension_added.connect ((info, extension) => {
            /* TODO handle extension setup during addition */
            debug ("%s router component was added", info.get_name ());
        });

        router_extensions.extension_removed.connect ((info, extension) => {
            /* TODO handle extension clean up after removal */
            debug ("%s router component was removed", info.get_name ());
        });
    }

    public void add_search_path (string path) {
        search_paths += path;
    }

    public string[] get_loaded_plugins () {
        return engine.loaded_plugins;
    }

    public void reload_plugins () {
        engine.rescan_plugins ();
    }

    public void enable_plugin (string plugin) throws GLib.Error {
        var info = engine.get_plugin_info (plugin);
        if (info == null) {
            throw new Ims.PluginError.NOT_FOUND (
                "Cannot enable %s, not found", plugin);
        }

        debug ("FIXME: this should be a plugin, not an extension");
    }

    public void disable_plugin (string plugin) throws GLib.Error {
        var info = engine.get_plugin_info (plugin);
        if (info == null) {
            throw new Ims.PluginError.NOT_FOUND (
                "Cannot disable %s, not found", plugin);
        }

        debug ("FIXME: this should be a plugin, not an extension");
    }
}
