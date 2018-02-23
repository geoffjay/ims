using VSGI;
using Valum;
using Valum.ContentNegotiation;

public class Ims.JobRouter : Ims.Router {

    construct {
        domain = "jobs";
        base_path = "/jobs";

        set_crud (create_cb, read_cb, update_cb, delete_cb);
    }

    private bool create_cb (Request req, Response res, NextCallback next, Context context, string content_type)
                            throws GLib.Error {
        debug ("Create job");

        switch (content_type) {
            case "application/json":
                /*
                 *try {
                 *    // TODO something
                 *} catch (GLib.Error e) {
                 *    throw new ClientError.BAD_REQUEST (
                 *        "Invalid or malformed JSON was provided");
                 *}
                 */

                var model = Ims.Model.get_default ();
                var uuid = model.jobs.create ();
                throw new Success.CREATED (uuid);
            default:
                throw new ClientError.BAD_REQUEST (
                    "Request used incorrect content type, 'application/json' expected");
        }
    }

    private bool read_cb (Request req, Response res, NextCallback next, Context context)
                          throws GLib.Error {
        debug ("Read job");

        var uuid = context["uuid"];

        var generator = new Json.Generator ();
        generator.pretty = false;

        if (uuid == null) {
            var job_array = new Json.Array ();
            var node = new Json.Node.alloc ();
            node.init_array (job_array);
            generator.set_root (node);
        } else {
            var object = new Json.Object ();
            var node = new Json.Node (Json.NodeType.OBJECT);
            node.set_object (object);
            generator.set_root (node);
        }

        return generator.to_stream (res.body);
    }

    private bool update_cb (Request req, Response res, NextCallback next, Context context, string content_type)
                            throws GLib.Error {
        debug ("Update job");

        var uuid = context["uuid"];
        if (uuid == null) {
            throw new ClientError.NOT_FOUND ("No job UUID was provided");
        }

        switch (content_type) {
            case "application/json":
                /*
                 *try {
                 *    // TODO something
                 *} catch (GLib.Error e) {
                 *    throw new ClientError.BAD_REQUEST (
                 *        "Invalid or malformed JSON was provided");
                 *}
                 */
                break;
            default:
                throw new ClientError.BAD_REQUEST (
                    "Request used incorrect content type, 'application/json' expected");
        }

        return res.end ();
    }

    private bool delete_cb (Request req, Response res, NextCallback next, Context context)
                            throws GLib.Error{
        debug ("Delete job");

        /*
         *var uuid = context["uuid"];
         *var model = Ims.Model.get_default ();
         *if (uuid != null) {
         *    model.jobs.delete (int.parse (uuid));
         *} else {
         *    model.jobs.delete_all ();
         *}
         */

        return res.end ();
    }
}
