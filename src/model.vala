public class Ims.Model : GLib.Object {

    /* FIXME Put all database related stuff into this database object */
    private Ims.Database db;

    private static Once<Ims.Model> _instance;

    /* Object repositories */
    public Repository<Ims.Image?> images { get; construct set; }

    /**
     * @return Singleton for the Config class
     */
    public static unowned Ims.Model get_default () {
        return _instance.once (() => { return new Ims.Model (); });
    }

    public void init () {
        db = new Ims.Database ();

        /* Create object repositories */
        images = new Repository<Ims.Image?> (db);
    }

    public class Repository<T> : GLib.Object {

        private Ims.Database db;
        protected string name;

        public Repository (Ims.Database db) {
            this.db = db;
            debug ("Created repository for %s objects", typeof (T).name ());
            /* FIXME This could be (more) generic */
            if (typeof (T).is_a (typeof (Ims.Image))) {
                name = "images";
            }

            var config = Ims.Config.get_default ();

            try {
                if (config.get_db_reset ()) {
                    db.delete_table (name);
                }
                db.create_table (name, typeof (T));
            } catch (Error e) {
                critical ("Error: %s", e.message);
            }
        }

        public virtual int count () {
            int n = 0;

            try {
                n = db.count (name);
            } catch (GLib.Error e) {
                critical (e.message);
            }

            return n;
        }

        /**
         * @return The id which is also the primary key value from the database
         */
        public virtual int create (T object) {
            Value id;
            try {
                //var type = (object as Object).get_type ();
                db.insert (name, object, out id);
            } catch (GLib.Error e) {
                critical (e.message);
            }

            return id.get_int ();
        }

        public virtual T? read (int id) {
            T[] records;
            try {
                var val_id = Value (typeof (int));
                val_id.set_int (id);
                records = db.select (name, val_id);
                /* FIXME This should probably throw an exception instead */
                if (records.length == 0) {
                    critical ("Read failed for ID '%d'", id);
                    return null;
                }
            } catch (GLib.Error e) {
                critical (e.message);
            }
            return records[0];
        }

        public virtual GLib.SList<T> read_all () {
            var list = new GLib.SList<T> ();
            try {
                T[] records = db.select (name, null);
                foreach (var record in records) {
                    list.append (record);
                }
            } catch (GLib.Error e) {
                critical (e.message);
            }
            return list;
        }

        public virtual GLib.SList<T> read_num (int n, int offset) {
            var list = new GLib.SList<T> ();
            try {
                T[] records = db.select (name, null, n, offset);
                foreach (var record in records) {
                    list.append (record);
                }
            } catch (GLib.Error e) {
                critical (e.message);
            }
            return list;
        }

        public virtual void update (T object) {
            try {
                db.update (name, object);
            } catch (GLib.Error e) {
                critical (e.message);
            }
        }

        public virtual void delete (int id) {
            try {
                var val_id = Value (typeof (int));
                val_id.set_int (id);
                db.delete (name, val_id);
            } catch (GLib.Error e) {
                critical (e.message);
            }
        }

        /**
         * Remove records where the given column has a given value
         *
         * @param column The name of the column
         * @param value The value that matches
         */
        public virtual void remove (string column, string value) {
            try {
                db.delete_where (name, column, value);
            } catch (GLib.Error e) {
                critical (e.message);
            }
        }

        public virtual void delete_all () {
            try {
                db.delete (name, null);
            } catch (GLib.Error e) {
                critical (e.message);
            }
        }
    }

    /**
     * XXX This is currently just here to test overriding methods from base
     */
    public class ImageRepository : Repository<Ims.Image?> {

        public ImageRepository (Ims.Database db) {
            base (db);
            name = "images";
        }
    }
}
