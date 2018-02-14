public errordomain Ims.PluginError {
    NOT_FOUND
}

public class Ims.PluginManager : GLib.Object {

    private Peas.Engine engine;
    private string[] search_paths = { Ims.PLUGINDIR };

    private Ims.Pipeline pipeline;
    private Ims.Router router;

    private Ims.PipelineManager pipeline_manager;
    //private Ims.RouteController route_controller;

    public signal void plugin_available (string name);

    public PluginManager () {
        engine = Peas.Engine.get_default ();

        var app = Ims.App.get_default ();
        pipeline = app.get_pipeline ();
        router = app.get_router ();

        setup_plugins ();

        pipeline_manager = new Ims.PipelineManager (pipeline);
        //route_controller = new Ims.RouteController (router);

        load_plugins ();
    }

    private void setup_plugins () {
        GLib.Environment.set_variable ("PEAS_ALLOW_ALL_LOADERS", "1", true);
        engine.enable_loader ("python3");

        try {
            var repo = GI.Repository.get_default();
            repo.require("Peas", "1.0", 0);
            repo.require("Ims", "1.0", 0);
        } catch (Error e) {
            message("Error loading typelibs: %s", e.message);
        }

        foreach (var path in search_paths) {
            debug ("Loading plugins from %s", path);
            engine.add_search_path (path, null);
        }

        engine.rescan_plugins ();
    }

    private void load_plugins () {
        foreach (var plugin in engine.get_plugin_list ()) {
            if (engine.try_load_plugin (plugin)) {
                debug (plugin.get_name () + " loaded by the plugin manager");
            }
        }
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

        debug ("Enable %s", plugin);
        if (engine.provides_extension (info, typeof (Ims.PipelineAddin))) {
            debug ("Plugin %s provides PipelineAddin extension", plugin);
            pipeline_manager.load_pipeline_addin (info);
        }
    }

    public void disable_plugin (string plugin) throws GLib.Error {
        var info = engine.get_plugin_info (plugin);
        if (info == null) {
            throw new Ims.PluginError.NOT_FOUND (
                "Cannot disable %s, not found", plugin);
        }

        debug ("Disable %s", plugin);
        if (engine.provides_extension (info, typeof (Ims.PipelineAddin))) {
            debug ("Plugin %s provides PipelineAddin extension", plugin);
            pipeline_manager.unload_pipeline_addin (info);
        }
    }
}
