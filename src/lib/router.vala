using VSGI;
using Valum;
using Valum.ContentNegotiation;

public abstract class Ims.Router : Valum.Router {

    public string domain { get; construct set; }

    public string base_path { get; construct set; }

    public delegate bool CreateCallback (Request req,
                                         Response res,
                                         NextCallback next,
                                         Context context,
                                         string content_type)
                                         throws GLib.Error;

    public delegate bool ReadCallback (Request req,
                                       Response res,
                                       NextCallback next,
                                       Context context,
                                       string content_type)
                                       throws GLib.Error;

    public delegate bool UpdateCallback (Request req,
                                         Response res,
                                         NextCallback next,
                                         Context context,
                                         string content_type)
                                         throws GLib.Error;

    public delegate bool DeleteCallback (Request req,
                                         Response res,
                                         NextCallback next,
                                         Context context)
                                         throws GLib.Error;

    public virtual void set_crud (CreateCallback create,
                                  ReadCallback read,
                                  UpdateCallback update,
                                  DeleteCallback @delete) {
        /* Add default rules for an object CRUD */
        rule (Method.POST,   "/",          accept ("application/json", (ForwardCallback<string>) create));
        rule (Method.GET,    "/(<uuid>)?", (HandlerCallback) read);
        rule (Method.PUT,    "/<uuid>",    accept ("application/json", (ForwardCallback<string>) update));
        rule (Method.DELETE, "/(<uuid>)?", (HandlerCallback) @delete);
    }
}
