public class Ims.Main : GLib.Object {

    private static string? filename;

    private const GLib.OptionEntry[] options = {
        // --config FILENAME || -c FILENAME
        { "config", 'c', 0, OptionArg.FILENAME, ref filename, "Configuration file", null },
        { null }
    };

    private Main () {
        if (filename != null) {
            var config = Ims.Config.get_default ();
            try {
                config.load_from_file (filename);
            } catch (GLib.Error e) {
                error (e.message);
            }
        }
    }

    private int run () {
        var app = Ims.App.get_default ();
        return app.run ();
    }

    private static int main (string[] args) {
        try {
            var context = new OptionContext ("- Image Manipulation Service");
            context.set_help_enabled (true);
            context.add_main_entries (options, null);
            context.parse (ref args);
        } catch (OptionError e) {
            critical (e.message);
            critical ("Run '%s --help' to see a list of options.", args[0]);
            return -1;
        }

        var main = new Ims.Main ();

        return main.run ();
    }
}
