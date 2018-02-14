/*
 *public interface Ims.PipelineAddin : GLib.Object, Peas.Activatable {
 *
 *    //public abstract GLib.Object object { construct; owned get; }
 *    public abstract GLib.Object object { get; construct set; }
 *
 *    //public abstract Ims.PipelineManager pipeline_manager { get; construct set; }
 *
 *    public abstract void load (Ims.PipelineManager pipeline_manager);
 *
 *    public abstract void unload (Ims.PipelineManager pipeline_manager);
 *
 *    public abstract void activate ();
 *
 *    public abstract void deactivate ();
 *
 *    public abstract void update_state ();
 *
 *    //public virtual void activate () { debug ("activate"); }
 *
 *    //public virtual void deactivate () { debug ("deactivate"); }
 *
 *    //public virtual void update_state () { debug ("update state"); }
 *}
 */

public interface Ims.PipelineAddin : GLib.Object {

    public abstract Ims.PipelineManager pipeline_manager { get; construct set; }

    public abstract void load (Ims.PipelineManager pipeline_manager);

    public abstract void unload (Ims.PipelineManager pipeline_manager);
}

/*
 *public abstract class Ims.PipelineAddinBase : Peas.ExtensionBase, Peas.Activatable, Ims.PipelineAddin {
 *
 *    public GLib.Object object { construct; owned get; }
 *
 *    public Ims.PipelineManager pipeline_manager { get; construct set; }
 *
 *    public void activate () {}
 *
 *    public void deactivate () {}
 *
 *    public void update_state () {}
 *
 *    public void load (Ims.PipelineManager pipeline_manager) {}
 *
 *    public void unload (Ims.PipelineManager pipeline_manager) {}
 *}
 */

public class Ims.PipelineAddinProxy : GLib.Object {

    public Ims.PipelineManager pipeline_manager { get; construct set; }

    public PipelineAddinProxy (Ims.PipelineManager pipeline_manager) {
        this.pipeline_manager = pipeline_manager;
    }
}
