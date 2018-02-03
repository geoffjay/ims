import gi
gi.require_version('Peas', '1.0')
gi.require_version('Ims', '1.0')
from gi.repository import GObject
from gi.repository import Peas
from gi.repository import Ims

class RotatePlugin(GObject.Object, Peas.Activatable):
    __gtype_name__ = 'RotatePlugin'

    object = GObject.property(type=GObject.Object)

    def __init__(self):
        self.element = RotateElement()

    def do_activate(self):
        print('Rotate plugin activated')
        #self.pipeline = object.get_pipeline()

    def do_deactivate(self):
        print('Rotate plugin deactivated')

    def do_update_state(self):
        print('Rotate plugin state updated')

class RotateElement(Ims.PipelineElement):
    __gtype_name__ = 'RotateElement'

    def __init__(self):
        print('Construct rotate pipeline element')
