public class Ims.App : GLib.Object {

    /* Application singleton */
    private static Once<Ims.App> _instance;

    private VSGI.Server server;
    private Ims.AppRouter router;
    private Ims.PluginManager plugin_manager;
    private bool running = false;

    public static unowned Ims.App get_default () {
        return _instance.once (() => { return new Ims.App (); });
    }

    public int run () {
        string[] _args;

        var settings = new GLib.Settings ("org.halfbaked.ims");
        var rest_settings = settings.get_child ("rest");

        var host = rest_settings.get_string ("host");
        var port = rest_settings.get_int ("port");
        var bind = "%s:%d".printf (host, port);
        _args = { "ims", "--address", bind };

        /* FIXME: Don't think this has any effect */
        running = true;

        /* FIXME: This initializes the data model, should be clearer */
        var model = Ims.Model.get_default ();
        model.verify ();

        /* Loads the plugins and extensions */
        plugin_manager = new Ims.PluginManager ();

        /* Load the REST API routes */
        router = new Ims.AppRouter ();
        /*
         *var image_router = new ImageRouter ();
         *router.add_router (image_router);
         *var pipeline_router = new PipelineRouter ();
         *router.add_router (pipeline_router);
         */

        router.add_router (new Ims.ElementRouter ());
        router.add_router (new Ims.ImageRouter ());
        router.add_router (new Ims.JobRouter ());
        router.add_router (new Ims.PipelineRouter ());

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

    public Ims.PluginManager get_plugin_manager () {
        return plugin_manager;
    }
}
