public class Ims.Model : GLib.Object {

    /* FIXME Put all database related stuff into this database object */
    private Ims.Database db;

    private static Once<Ims.Model> _instance;

    /* Object repositories */
    public Ims.Repository<Ims.Element> elements { get; construct set; }

    public Ims.Repository<Ims.Image> images { get; construct set; }

    public Ims.Repository<Ims.Job> jobs { get; construct set; }

    public Ims.Repository<Ims.Pipeline> pipelines { get; construct set; }

    /**
     * @return Singleton for the Config class
     */
    public static unowned Ims.Model get_default () {
        return _instance.once (() => { return new Ims.Model (); });
    }

    private Model () {
        db = new Ims.Database ();
        elements = new Ims.Repository<Ims.Element> ();
        images = new Ims.Repository<Ims.Image> ();
        jobs = new Ims.Repository<Ims.Job> ();
        pipelines = new Ims.Repository<Ims.Pipeline> ();

        jobs.item_created.connect (job_created_cb);
        jobs.item_updated.connect (job_updated_cb);
        jobs.item_deleted.connect (job_deleted_cb);
    }

    public void verify () {
        debug ("Model verification doesn't do anything");
    }

    public void test_db () {
        db.test ();
    }

    private void job_created_cb (string uuid) {
        debug ("Signal create Job in database");
        try {
            db.add (uuid, jobs.read<Ims.Job> (uuid));
        } catch (Ims.DatabaseError de) {
            warning (de.message);
        }
    }

    private void job_updated_cb (string uuid) {
        debug ("Signal update Job in database");
        try {
            db.replace (uuid, jobs.read<Ims.Job> (uuid));
        } catch (Ims.DatabaseError de) {
            warning (de.message);
        }
    }

    private void job_deleted_cb (string uuid) {
        debug ("Signal delete Job in database");
        try {
            db.remove (uuid);
        } catch (Ims.DatabaseError de) {
            warning (de.message);
        }
    }

    /**
     * XXX This is currently just here to test overriding methods from base
     */
/*
 *    public class Ims.ImageRepository : Ims.Repository<Ims.Image?> {
 *
 *        public ImageRepository (Ims.Database db) {
 *            base (db);
 *            name = "images";
 *        }
 *    }
 */
}
