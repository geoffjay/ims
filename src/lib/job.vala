public enum Ims.JobState {
    READY,
    NOT_READY
}

public class Ims.Job : GLib.Object {

    [Description (blurb = "ignore")]
    public Ims.JobState state { get; set; }

    public string name { get; set; }

    [Description (blurb = "ignore")]
    public Ims.Pipeline pipeline { get; set; }

    public Job () { name = "job"; }
}
