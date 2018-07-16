public enum Ims.ElementType {
    MUX,
    DEMUX,
    FILTER
}

public class Ims.Element : GLib.Object {

    public string uuid { get; set; }

    private GLib.HashTable<string, Variant> inputs;

    private GLib.HashTable<string, Variant> outputs;

    public Element () {
        inputs = new GLib.HashTable<string, Variant> (null, null);
        outputs = new GLib.HashTable<string, Variant> (null, null);
    }

    /**
     * XXX Something needs to be runnable for the element, initially considered
     * using a delegate but I'm not sure how to implement that if using Python
     * for plugins.
     */
    //public abstract void operation ();

    /**
     * Specifies whether the objects provided are equivalent for sorting.
     *
     * @param a one of the objects to use in the comparison.
     * @param b the other object to use in the comparison.
     *
     * @return  ``true`` or ``false`` depending on whether or not the id
     *          parameters match
     */
    public static bool equal (Ims.Element a, Ims.Element b) {
        return a.uuid == b.uuid;
    }

    /**
     * Compares the object to another that is provided.
     *
     * @param a the object to compare this one against.
     *
     * @return  ``0`` if they contain the same uuid, ``1`` otherwise
     */
    public int compare (Ims.Element a) {
        return this.uuid.ascii_casecmp (a.uuid);
    }

    /**
     * XXX Should these be exceptions instead of assertions? Adding these as
     * placeholders for now.
     */

    public void add_input (string name, Variant value) {
        assert (!inputs.contains (name));
        inputs.set (name, value);
    }

    public void add_output (string name, Variant value) {
        assert (!outputs.contains (name));
        outputs.set (name, value);
    }

    public void set_input (string name, Variant value) {
        assert (inputs.contains (name));
        inputs.set (name, value);
    }

    public void set_output (string name, Variant value) {
        assert (outputs.contains (name));
        outputs.set (name, value);
    }

    public Variant get_input (string name) {
        assert (inputs.contains (name));
        return inputs.get (name);
    }

    public Variant get_output (string name) {
        assert (outputs.contains (name));
        return outputs.get (name);
    }

    public void add_inputs (...) {
        var list = va_list ();
        while (true) {
            string? key = list.arg ();
            if (key == null) {
                break;
            }
            Variant value = list.arg ();
            inputs.set (key, value);
        }
    }

    public void add_outputs (...) {
        var list = va_list ();
        while (true) {
            string? key = list.arg ();
            if (key == null) {
                break;
            }
            Variant value = list.arg ();
            outputs.set (key, value);
        }
    }

    public GLib.List<Gdk.Pixbuf> map_inputs_to_images () {
        var images = new GLib.List<Gdk.Pixbuf> ();

        inputs.foreach ((key, input) => {
            if (input.check_format_string ("(iiibiay)", true)) {
                int width = -1,
                    height = -1,
                    stride = -1,
                    bits_per_sample = -1;
                bool has_alpha = false;
                var iter = input.iterator ();
                iter.next ("i", &width);
                iter.next ("i", &height);
                iter.next ("i", &stride);
                iter.next ("b", &has_alpha);
                iter.next ("i", &bits_per_sample);
                uint8[] data = new uint8[width * height * 3];
                iter.next ("ay", &data);
                var image = new Gdk.Pixbuf.from_data (data,
                                                      Gdk.Colorspace.RGB,
                                                      has_alpha,
                                                      bits_per_sample,
                                                      width,
                                                      height,
                                                      stride);
                images.append (image);
            }
        });

        return images.copy ();
    }
}
