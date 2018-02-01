using VSGI;
using Valum;
using Valum.Static;
using Valum.ContentNegotiation;

public class Ims.Router : Valum.Router {

    construct {
        use ((req, res, next) => {
            res.headers.append ("Server", "Ims/1.0");
            HashTable<string, string>? @params = new HashTable<string, string> (str_hash, str_equal);
            @params["charset"] = "utf-8";
            res.headers.set_content_type ("application/json", @params);
            res.headers.append ("Access-Control-Allow-Origin", "*");
            res.headers.append ("Access-Control-Allow-Methods", "GET, POST, OPTIONS, PUT, DELETE");
            res.headers.append ("Access-Control-Allow-Headers",
                                "Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
            return next ();
        });
    }

    public void add_router (Valum.Router router, string domain, string path) {
        use (subdomain (domain, router.handle));
        use (basepath (path, router.handle));
    }
}
