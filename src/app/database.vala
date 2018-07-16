using Couchbase;
using LibCouchbase;

public errordomain Ims.DatabaseError {
    GET,
    ADD,
    SET,
    REPLACE,
    REMOVE,
    FLUSH
}

/**
 * TODO: Move this into unit tests
 */
internal class Ims.TestObject : Object {
    /* Simple value types */
    public string s_val { get; set; }
    public int i_val { get; set; }
    public double f_val { get; set; }
    public bool b_val { get; set; }
    public DateTime dt_val {
        get; set; default = new DateTime.now_local ();
    }

    /* List/Array value types */
    public string[] s_a_val { get; set; }
    public Gee.ArrayList<string> s_al_val {
        get; set; default = new Gee.ArrayList<string> ();
    }

    /* Object types */
    [Description (blurb = "ignore")]
    public Object o_val { get; set; }
    public Couchbase.JSON.Node n_val { get; set; }

    public TestObject.with_data () {
        s_val = "s-val";
        i_val = 1;
        f_val = 2.2;
        b_val = true;

        s_a_val = { "s-a-val-1", "s-a-val-2" };
        s_al_val.add ("s-al-val-1");
        s_al_val.add ("s-al-val-2");

        // XXX For now
        //o_val = new Ims.TestObject.SubObject.with_data ();
        var builder = new Json.Builder ();
        builder.begin_object ();
        builder.set_member_name ("n-val-1");
        builder.add_string_value ("n-val-1-1");
        builder.set_member_name ("n-val-2");
        builder.add_string_value ("n-val-2");
        builder.set_member_name ("n-val-i-a");
        builder.begin_array ();
        builder.add_int_value (1);
        builder.add_int_value (2);
        builder.end_array ();
        builder.end_object ();
        n_val = new JSON.Node (builder.get_root ());
    }

    public string to_string () {
        size_t length = -1;
        string data = Json.gobject_to_data (this, out length);
        return data;
    }
}

public class Ims.Database : Object {

    private Couchbase.Client client;

    public Database () {
        var settings = new Settings ("org.halfbaked.ims");
        var db_settings = settings.get_child ("database");

        try {
            var bucket = db_settings.get_string ("bucket");
            var host = db_settings.get_string ("host");
            var user = db_settings.get_string ("user");
            var password = db_settings.get_string ("password");

            /* TODO: Test settings and throw exception on something dumb */

            client = new Couchbase.Client (host, bucket, user, password);
        } catch (Couchbase.ClientError ce) {
            /* TODO: Throw exception */
            critical ("Error connecting Couchbase client: %s", ce.message);
        }
    }

    public void test () {
        var obj = new Ims.TestObject.with_data ();
        try {
            @set ("test_object", obj);
            var t_obj = @get<Ims.TestObject> ("test_object");
            debug (t_obj.to_string ());
        } catch (Ims.DatabaseError de) {
            critical (de.message);
        }
    }

    public T? @get<T> (string uuid) throws Ims.DatabaseError {
        T? document = client.get_object<T> (uuid);
        if (document == null) {
            throw new Ims.DatabaseError.GET (
                "Failed to get object with key: %s", uuid
            );
        }

        return document;
    }

    public T[] get_all<T> () throws Ims.DatabaseError {
        // TODO: Return a query result
        T[] results = new T[0];
        return results;
    }

    /**
     * Add a new object with the provided UUID and document data.
     *
     * @param uuid ID of the document
     * @param document Document to store
     * @throws Ims.DatabaseError
     */
    public void add (string uuid, Object document) throws Ims.DatabaseError {
        bool result = client.add_object (uuid, document);
        if (!result) {
            throw new Ims.DatabaseError.ADD (
                "Failed to add object with key: %s", uuid
            );
        }
    }

    /**
     * Overwrite an object with the provided UUID and document data.
     *
     * @param uuid ID of the document
     * @param document Document to store
     * @throws Ims.DatabaseError
     */
    public void @set (string uuid, Object document) throws Ims.DatabaseError {
        bool result = client.set_object (uuid, document);
        if (!result) {
            throw new Ims.DatabaseError.SET (
                "Failed to set object with key: %s", uuid
            );
        }
    }

    /**
     * Replace an object with the provided UUID and document data.
     *
     * @param uuid ID of the document
     * @param document Document to store
     * @throws Ims.DatabaseError
     */
    public void replace (string uuid, Object document) throws Ims.DatabaseError {
        bool result = client.replace_object (uuid, document);
        if (!result) {
            throw new Ims.DatabaseError.REPLACE (
                "Failed to replace object with key: %s", uuid
            );
        }
    }

    /**
     * Remove an object with the provided UUID.
     *
     * @param uuid ID of the document
     * @throws Ims.DatabaseError
     */
    public void remove (string uuid) throws Ims.DatabaseError {
        bool result = client.remove (uuid);
        if (!result) {
            throw new Ims.DatabaseError.REMOVE (
                "Failed to replace object with key: %s", uuid
            );
        }
    }

    /**
     * Empty the database bucket.
     *
     * @throws Ims.DatabaseError
     */
    public void flush () throws Ims.DatabaseError {
        var response = client.instance.flush (null, null);
        switch (response) {
            case StatusResponse.SUCCESS:
                debug ("Successfully flushed the database bucket");
                break;
            default:
                throw new Ims.DatabaseError.FLUSH (
                    "Received error while attempting to flush the database bucket"
                );
        }
    }
}
