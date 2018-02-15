using VSGI;
using Valum;
using Valum.Static;
using Valum.ContentNegotiation;

public abstract class Ims.Router : Valum.Router {

    public string domain { get; construct set; }

    public string path { get; construct set; }

    public void add_router (Ims.Router router) {
        use (subdomain (router.domain, router.handle));
        use (basepath (path + router.path, router.handle));
    }
}
