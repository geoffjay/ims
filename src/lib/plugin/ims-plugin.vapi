namespace Ims {
    [CCode (cheader_filename = "ims-plugin.h")]
    public class Plugin : GLib.Object {
        public Plugin ();

        public void load ();
        public void unload ();
    }
}
