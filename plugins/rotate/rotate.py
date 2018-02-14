import gi

gi.require_version('Ims', '1.0')
gi.require_version('Peas', '1.0')

from gi.repository import GLib
from gi.repository import GObject
from gi.repository import Peas
from gi.repository import Ims

# class RotatePlugin(GObject.Object, Peas.Activatable):
class RotatePlugin(GObject.Object, Ims.PipelineAddin):
    __gtype_name__ = 'RotatePlugin'

    object = GObject.property(type=GObject.Object)

    def __init__(self):
        GObject.Object.__init__(self)
        print('Construct rotate pipeline addin')
        self.element = RotateElement()

    def do_get_element(self):
        return self.element

    # def do_activate(self):
        # print('Rotate plugin activated')

    # def do_deactivate(self):
        # print('Rotate plugin deactivated')

    # def do_update_state(self):
        # print('Rotate plugin state updated')

# class RotateAddin(GObject.Object, Peas.Activatable):
    # __gtype_name__ = 'RotateAddin'

    # object = GObject.property(type=GObject.Object)

    # # pipeline_manager = GObject.property(type=Ims.PipelineManager)
    # # pipeline_manager = None

    # def do_load(self, pipeline_manager):
        # print('Load rotate pipeline addin')
        # # self.pipeline_manager = self.object.get_pipeline_manager()

    # def do_unload(self, pipeline_manager):
        # print('Unload rotate pipeline addin')

# XXX Should there also be an Ims.PipelineElementProvider class?

class RotateElement(Ims.PipelineElement):
    __gtype_name__ = 'RotateElement'

    def __init__(self):
        print('Construct rotate pipeline element')
