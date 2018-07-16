public class PipelineTest {

    public static void add_tests () {
        Test.add_func ("/pipeline/construct", () => {
            var pipeline = new Ims.Pipeline ();
            assert (pipeline != null);
            assert (pipeline.position == 0);
        });

        /* Element tests */

        Test.add_func ("/pipeline/element/count", () => {
            var pipeline = get_pipeline ();
            assert (pipeline.element_count () == 0);
            pipeline.append_element (new Ims.Element ());
            assert (pipeline.element_count () == 1);
        });

        Test.add_func ("/pipeline/element/append", () => {
            var pipeline = get_pipeline ();
            var el = new Ims.Element ();
            var uuid = GLib.Uuid.string_random ();
            el.uuid = uuid;
            try {
                pipeline.append_element (el);
                assert (pipeline.element_count () == 1);
            } catch (GLib.Error e) {
                assert_not_reached ();
            }
        });

        Test.add_func ("/pipeline/element/prepend", () => {
            var pipeline = get_pipeline ();
            try {
            } catch (GLib.Error e) {
                assert_not_reached ();
            }
        });

        Test.add_func ("/pipeline/element/insert", () => {
            var pipeline = get_pipeline ();
            try {
            } catch (GLib.Error e) {
                assert_not_reached ();
            }
        });

        Test.add_func ("/pipeline/element/remove", () => {
            var pipeline = get_pipeline ();
            try {
            } catch (GLib.Error e) {
                assert_not_reached ();
            }
        });

        Test.add_func ("/pipeline/element/current", () => {
            var pipeline = get_pipeline ();
            try {
            } catch (GLib.Error e) {
                assert_not_reached ();
            }
        });

        Test.add_func ("/pipeline/element/contains", () => {
            var pipeline = get_pipeline ();
            var el = new Ims.Element ();
            var uuid = GLib.Uuid.string_random ();
            el.uuid = uuid;
            try {
                pipeline.append_element (el);
            } catch (GLib.Error e) {
                assert_not_reached ();
            }
            var test_el = pipeline.get_element (uuid);
            assert (test_el != null);
            assert (pipeline.contains_element (uuid));
        });

        /* State tests */

        Test.add_func ("/pipeline/state/start", () => {
            var pipeline = get_pipeline ();
            try {
            } catch (GLib.Error e) {
                assert_not_reached ();
            }
        });

        Test.add_func ("/pipeline/state/stop", () => {
            var pipeline = get_pipeline ();
            try {
            } catch (GLib.Error e) {
                assert_not_reached ();
            }
        });

        Test.add_func ("/pipeline/state/pause", () => {
            var pipeline = get_pipeline ();
            try {
            } catch (GLib.Error e) {
                assert_not_reached ();
            }
        });
    }

    public static Ims.Pipeline get_pipeline () {
        Ims.Pipeline pipeline = new Ims.Pipeline ();
        return pipeline;
    }
}

public int main (string[] args) {
    Test.init (ref args);
    PipelineTest.add_tests ();
    return Test.run ();
}
