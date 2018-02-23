using VSGI;
using Valum;
using Valum.ContentNegotiation;

/**
 * XXX This router could disappear, the images may only ever be stored as an
 * XXX Element input or output. Maybe.
 */

public class Ims.ImageRouter : Ims.Router {

    construct {
        domain = "images";
        base_path = "/images";

        rule (Method.GET,
              "/(<int:uuid>)?",
              view_cb);
        rule (Method.PUT,
              "/<int:uuid>",
              accept ("application/json", edit_cb));
        rule (Method.POST,
              "/",
              accept ("application/json", create_cb));
        rule (Method.DELETE,
              "/(<int:uuid>)?",
              delete_cb);
    }

    private bool view_cb (Request req, Response res, NextCallback next, Context context)
                          throws GLib.Error {
        var uuid = context["uuid"];

        var generator = new Json.Generator ();
        generator.pretty = false;

        if (uuid == null) {
            var image_array = new Json.Array ();
            var node = new Json.Node.alloc ();
            node.init_array (image_array);
            generator.set_root (node);
        } else {
            var object = new Json.Object ();
            var node = new Json.Node (Json.NodeType.OBJECT);
            node.set_object (object);
            generator.set_root (node);
        }

        return generator.to_stream (res.body);
    }

    private bool edit_cb (Request req, Response res, NextCallback next, Context context, string content_type)
                          throws GLib.Error {
        var uuid = context["uuid"];
        if (uuid == null) {
            throw new ClientError.NOT_FOUND ("No image UUID was provided");
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
         *    model.images.delete (int.parse (uuid));
         *} else {
         *    model.images.delete_all ();
         *}
         */

        return res.end ();
    }
}
