public errordomain Ims.PipelineError {
    APPEND,
    PREPEND,
    INSERT,
    REMOVE,
    EXECUTION,
    STATE_CHANGE
}

public enum Ims.PipelineState {
    READY,
    NOT_READY,
    RUNNING,
    STARTED,
    STOPPED,
    PAUSED;

    public string to_string () {
        switch (this) {
            case READY:     return "ready";
            case NOT_READY: return "not ready";
            case RUNNING:   return "running";
            case STARTED:   return "started";
            case STOPPED:   return "stopped";
            case PAUSED:    return "paused";
            default: assert_not_reached ();
        }
    }
}

public class Ims.Pipeline : GLib.Object {

    public string uuid { get; set; }

    public Gee.ArrayList<Ims.Element> elements { get; set; }

    public int position { get; set; default = 0; }

    [Description (blurb = "ignore")]
    public Ims.PipelineState state { get; private set; }

    private Gee.ArrayList<Ims.PipelineState> state_history;

    public signal void state_changed (Ims.PipelineState from, Ims.PipelineState to);

    public Pipeline () {
        elements = new Gee.ArrayList<Ims.Element> (Ims.Element.equal);
        state_history = new Gee.ArrayList<Ims.PipelineState> ();
        state = Ims.PipelineState.NOT_READY;
    }

    private void change_state (Ims.PipelineState new_state) throws Ims.PipelineError {
        switch (new_state) {
            case Ims.PipelineState.READY:
                // Allow:
                //   NOT_READY -> READY
                if (state != Ims.PipelineState.NOT_READY) {
                    throw new Ims.PipelineError.STATE_CHANGE (
                        "Can't change pipline state from %s to %s",
                        state.to_string (),
                        new_state.to_string ()
                    );
                }
                break;
            case Ims.PipelineState.NOT_READY:
                // Allow:
                //   READY   -> NOT_READY
                //   RUNNING -> NOT_READY
                //   STARTED -> NOT_READY
                //   STOPPED -> NOT_READY
                //   PAUSED  -> NOT_READY
                if (state != Ims.PipelineState.READY ||
                    state != Ims.PipelineState.RUNNING ||
                    state != Ims.PipelineState.STARTED ||
                    state != Ims.PipelineState.STOPPED ||
                    state != Ims.PipelineState.PAUSED) {
                    throw new Ims.PipelineError.STATE_CHANGE (
                        "Can't change pipline state from %s to %s",
                        state.to_string (),
                        new_state.to_string ()
                    );
                }
                break;
            case Ims.PipelineState.RUNNING:
                // Allow:
                //   STARTED -> RUNNING
                if (state != Ims.PipelineState.STARTED) {
                    throw new Ims.PipelineError.STATE_CHANGE (
                        "Can't change pipline state from %s to %s",
                        state.to_string (),
                        new_state.to_string ()
                    );
                }
                break;
            case Ims.PipelineState.STARTED:
                // Allow:
                //   READY   -> STARTED
                //   STOPPED -> STARTED
                //   PAUSED  -> STARTED
                if (state != Ims.PipelineState.READY ||
                    state != Ims.PipelineState.STOPPED ||
                    state != Ims.PipelineState.PAUSED) {
                    throw new Ims.PipelineError.STATE_CHANGE (
                        "Can't change pipline state from %s to %s",
                        state.to_string (),
                        new_state.to_string ()
                    );
                }
                break;
            case Ims.PipelineState.STOPPED:
                // Allow:
                //   RUNNING -> STOPPED
                //   PAUSED  -> STOPPED
                if (state != Ims.PipelineState.RUNNING ||
                    state != Ims.PipelineState.PAUSED) {
                    throw new Ims.PipelineError.STATE_CHANGE (
                        "Can't change pipline state from %s to %s",
                        state.to_string (),
                        new_state.to_string ()
                    );
                }
                break;
            case Ims.PipelineState.PAUSED:
                // Allow:
                //   RUNNING -> PAUSED
                if (state != Ims.PipelineState.RUNNING) {
                    throw new Ims.PipelineError.STATE_CHANGE (
                        "Can't change pipline state from %s to %s",
                        state.to_string (),
                        new_state.to_string ()
                    );
                }
                break;
            // Should never get here
            default:
                break;
        }

        state_history.add (state);
        state_changed (state, new_state);
        state = new_state;
    }

    public Ims.PipelineState previous_state () {
        return state_history.get (state_history.size - 1);
    }

    public int element_count () {
        return elements.size;
    }

    public void append_element (Ims.Element element) throws GLib.Error {
        elements.add (element);
        if (!elements.contains (element)) {
            throw new Ims.PipelineError.APPEND ("Could not append element");
        }
    }

    public void prepend_element (Ims.Element element) throws GLib.Error {
        elements.insert (0, element);
        if (!elements.contains (element)) {
            throw new Ims.PipelineError.PREPEND ("Could not prepend element");
        }
    }

    public void insert_element (int index, Ims.Element element) throws GLib.Error {
        elements.insert (index, element);
        if (!elements.contains (element)) {
            throw new Ims.PipelineError.INSERT ("Could not insert element");
        }
    }

    public void remove_element (Ims.Element element) throws GLib.Error {
        var result = elements.remove (element);
        if (!result) {
            throw new Ims.PipelineError.REMOVE ("Could not remove element");
        }
    }

    public Ims.Element? get_element (string uuid) {
        foreach (var element in elements) {
            if (element.uuid == uuid) {
                return element;
            }
        }
        return null;
    }

    public bool contains_element (string uuid) {
        foreach (var element in elements) {
            if (element.uuid == uuid) {
                return true;
            }
        }
        return false;
    }

    public Ims.Element current_element () {
        return elements.get (position);
    }

    public void start () throws GLib.Error {
        try {
            change_state (Ims.PipelineState.STARTED);
        } catch (Ims.PipelineError e) {
            throw e;
        }
    }

    public void stop () throws GLib.Error {
        try {
            change_state (Ims.PipelineState.STOPPED);
        } catch (Ims.PipelineError e) {
            throw e;
        }
    }

    public void pause () throws GLib.Error {
        try {
            change_state (Ims.PipelineState.PAUSED);
        } catch (Ims.PipelineError e) {
            throw e;
        }
    }

    private async void process () throws GLib.ThreadError {
    }
}
