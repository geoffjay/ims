[DBus (name = "org.halfbaked.Ims")]
public class Ims.DBus : GLib.Object {

    private Ims.App app;
    private Ims.PluginManager plugin_manager;

    construct {
        app = Ims.App.get_default ();
        plugin_manager = app.get_plugin_manager ();
    }

    /* XXX: define documentation header */
    /*
     * <desc>
     *
     * @param
     * @error
     * @returns
     */

    public void quit () {
        app.shutdown ();
    }

    /* Plugin related methods */

    public string[] get_loaded_plugins () {
        return plugin_manager.get_loaded_plugins ();
    }

    public void reload_plugins () {
        plugin_manager.reload_plugins ();
    }

    public void enable_plugin (string plugin) {
        try {
            plugin_manager.enable_plugin (plugin);
        } catch (Error e) {
            warning (e.message);
            // TODO: throw new plugin error
        }
    }

    public void disable_plugin (string plugin) {
        try {
            plugin_manager.disable_plugin (plugin);
        } catch (Error e) {
            warning (e.message);
            // TODO: throw new plugin error
        }
    }
}
