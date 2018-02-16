import gi

gi.require_version('Ims', '1.0')

from gi.repository import GLib
from gi.repository import GObject
from gi.repository import Ims

class RotatePlugin(GObject.Object, Ims.Plugin):
    __gtype_name__ = 'RotatePlugin'

    object = GObject.property(type=GObject.Object)

    def __init__(self):
        GObject.Object.__init__(self)
        print('Construct rotate pipeline addin')

    def do_load(self):
        print('Load rotate plugin')

    def do_unload(self):
        print('Unload rotate plugin')

# class RotateElementProvider(GObject.Object, Ims.ElementProvider):
    # __gtype_name__ = 'RotateElementProvider'

    # def __init__(self):
        # GObject.Object.__init__(self)
        # print('Construct rotate pipeline element provider')
        # self.element = RotateElement()

    # def do_get_element(self):
        # return self.element

# class RotateElement(Ims.Element):
    # __gtype_name__ = 'RotateElement'

    # def __init__(self):
        # GObject.Object.__init__(self)
        # print('Construct rotate pipeline element')
