using VSGI;
using Valum;
using Valum.Static;
using Valum.ContentNegotiation;

public class Ims.AppRouter : Ims.Router {

    construct {
        domain = "ims";
        base_path = "/api";

        use (basic ());

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

        get ("/api/test", (req, res) => {
            var builder = new Json.Builder ();
            var generator = new Json.Generator ();

            builder.begin_object ();
            builder.set_member_name ("test");
            builder.add_string_value ("ok");
            builder.end_object ();

            generator.root = builder.get_root ();
            generator.pretty = false;

            return generator.to_stream (res.body);
        });
    }

    public void add_router (Ims.Router router) {
        use (subdomain (router.domain, router.handle));
        use (basepath (base_path + router.base_path, router.handle));
    }
}
