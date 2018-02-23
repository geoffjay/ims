/*
 *public errordomain PipelineError {
 *    EXECUTION_FAILED
 *}
 */

public class Ims.Pipeline : GLib.Object {

    public string uuid { get; set; }

    public Gee.ArrayList<Ims.Element> elements { get; set; }

    public int position { get; set; default = 0; }

    public Pipeline () {
        elements = new Gee.ArrayList<Ims.Element> ();
    }

    public void register_element (Ims.Element element) {
        elements.add (element);
        debug ("Do a thing");
    }

    public void test_elements () {
        foreach (var element in elements) {
            var type = element.get_type ();
            debug ("Element %s registered", type.name ());
        }
    }

    public void add_element (Ims.Element element) throws GLib.Error {
    }

    public void remove_element (Ims.Element element) throws GLib.Error {
    }

    public void start_execution () throws GLib.Error {
    }

    public void stop_execution () throws GLib.Error {
    }

    public async void process () throws GLib.ThreadError {
    }
}
