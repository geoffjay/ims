using VSGI;
using Valum;
using Valum.ContentNegotiation;

public class Ims.ElementRouter : Ims.Router {

    construct {
        domain = "elements";
        base_path = "/elements";

        set_crud (create_cb, read_cb, update_cb, delete_cb);
    }

    private bool create_cb (Request req, Response res, NextCallback next, Context context, string content_type)
                            throws GLib.Error {
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
                var uuid = model.elements.create ();
                throw new Success.CREATED (
                    "Created new element with UUID: %s", uuid);
            default:
                throw new ClientError.BAD_REQUEST (
                    "Request used incorrect content type, 'application/json' expected");
        }

        return res.end ();
    }

    private bool read_cb (Request req, Response res, NextCallback next, Context context)
                          throws GLib.Error {
        var uuid = context["uuid"];

        var generator = new Json.Generator ();
        generator.pretty = false;

        if (uuid == null) {
            var element_array = new Json.Array ();
            var node = new Json.Node.alloc ();
            node.init_array (element_array);
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
        var uuid = context["uuid"];
        if (uuid == null) {
            throw new ClientError.NOT_FOUND ("No element UUID was provided");
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
        /*
         *var uuid = context["uuid"];
         *var model = Ims.Model.get_default ();
         *if (uuid != null) {
         *    model.elements.delete (int.parse (uuid));
         *} else {
         *    model.elements.delete_all ();
         *}
         */

        return res.end ();
    }
}
