using VSGI;
using Valum;
using Valum.ContentNegotiation;

public class Ims.PipelineRouter : Ims.Router {

    construct {
        domain = "pipelines";
        base_path = "/pipelines";

        set_crud (create_cb, view_cb, edit_cb, delete_cb);

        /*
         *rule (Method.GET,
         *      "/(<int:uuid>)?",
         *      view_cb);
         *rule (Method.PUT,
         *      "/<int:uuid>",
         *      accept ("application/json", edit_cb));
         *rule (Method.POST,
         *      "/",
         *      accept ("application/json", create_cb));
         *rule (Method.DELETE,
         *      "/(<int:uuid>)?",
         *      delete_cb);
         */
    }

    private bool view_cb (Request req, Response res, NextCallback next, Context context)
                          throws GLib.Error {
        var uuid = context["uuid"];

        var generator = new Json.Generator ();
        generator.pretty = false;

        if (uuid == null) {
            var pipeline_array = new Json.Array ();
            var node = new Json.Node.alloc ();
            node.init_array (pipeline_array);
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
            throw new ClientError.NOT_FOUND ("No pipeline UUID was provided");
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

                var model = Ims.Model.get_default ();
                var uuid = model.pipelines.create ();
                throw new Success.CREATED (
                    "Created new pipeline with UUID: %s", uuid);
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
         *    model.pipelines.delete (int.parse (uuid));
         *} else {
         *    model.pipelines.delete_all ();
         *}
         */

        return res.end ();
    }
}
