/**
 * A complete configuration file may contain:
 *
 * {{{
 * [general]
 * address = 127.0.0.1
 * port = 3003
 * }}}
 *
 * FIXME: This is an old concept that was replaced by GSettings.
 */
[Version (deprecated = true)]
public class Ims.Config : GLib.Object {

    private GLib.KeyFile file;
    private static Once<Ims.Config> _instance;

    /* [general] backing fields */
    private string address = "127.0.0.1";
    private int port = 3003;

    public bool is_loaded { get; private set; default = false; }

    /**
     * @return Singleton for the Config class
     */
    public static unowned Ims.Config get_default () {
        return _instance.once (() => { return new Ims.Config (); });
    }

    public void load_from_file (string filename) throws GLib.Error {
        is_loaded = true;
        file = new GLib.KeyFile ();
        try {
            file.load_from_file (filename, KeyFileFlags.NONE);
        } catch (GLib.Error e) {
            is_loaded = false;
            throw e;
        }
    }

    public string get_address () throws GLib.Error {
        if (is_loaded) {
            try {
                address = file.get_string ("general", "address");
            } catch (GLib.Error e) {
                if (e is KeyFileError.KEY_NOT_FOUND ||
                    e is KeyFileError.GROUP_NOT_FOUND) {
                    debug ("An address wasn't configured, using default '%s'", address);
                } else {
                    throw e;
                }
            }
        }

        return address;
    }

    public int get_port () throws GLib.Error {
        if (is_loaded) {
            try {
                port = file.get_integer ("general", "port");
            } catch (GLib.Error e) {
                if (e is KeyFileError.KEY_NOT_FOUND ||
                    e is KeyFileError.GROUP_NOT_FOUND) {
                    debug ("A port wasn't configured, using default '%d'", port);
                } else {
                    throw e;
                }
            }
        }

        return port;
    }
}
