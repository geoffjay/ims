public class Ims.App : GLib.Object {

    /* Application singleton */
    private static Once<Ims.App> _instance;

    private VSGI.Server server;
    private Ims.Router router;
    private Ims.Pipeline pipeline;
    private Ims.PluginManager plugin_manager;
    private bool running = false;

    public static unowned Ims.App get_default () {
        return _instance.once (() => { return new Ims.App (); });
    }

    public int run () {
        //var config = Ims.Config.get_default ();
        string[] _args;

        var settings = new GLib.Settings ("org.halfbaked.Ims");

        try {
            //var bind = "%s:%d".printf (config.get_address (), config.get_port ());
            var host = settings.get_string ("host");
            var port = settings.get_int ("port");
            var bind = "%s:%d".printf (host, port);
            _args = { "ims", "--address", bind };
        } catch (GLib.Error e) {
            error (e.message);
        }

        pipeline = new Ims.Pipeline ();

        router = new Ims.Router ();
        var image_router = new ImageRouter ();
        router.add_router (image_router, "images", "/api/images");

        plugin_manager = new Ims.PluginManager ();
        var model = Ims.Model.get_default ();
        model.init ();

        running = true;

        server = VSGI.Server.@new ("http", handler: router);
        return server.run (_args);
    }

    /**
     * FIXME: this doesn't actually work, not sure why yet
     */
    public void shutdown () {
        server.stop ();
        running = false;
    }

    public Ims.Router get_router () {
        return router;
    }

    public Ims.Pipeline get_pipeline () {
        return pipeline;
    }

    public Ims.PluginManager get_plugin_manager () {
        return plugin_manager;
    }
}
