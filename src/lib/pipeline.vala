public errordomain PipelineError {
    EXECUTION_FAILED
}

public class Ims.Pipeline : GLib.Object {

    Gee.ArrayList<Ims.PipelineElement> elements;

    public Pipeline () {
    }

    public void add_element (Ims.PipelineElement element) throws GLib.Error {
    }

    public void remove_element (Ims.PipelineElement element) throws GLib.Error {
    }

    public void start_execution () throws GLib.Error {
    }

    public void stop_execution () throws GLib.Error {
    }

    public async void process () throws GLib.ThreadError {
    }
}
