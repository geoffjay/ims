# Ims plugin core
gnome = import('gnome')
pkgconfig = import('pkgconfig')

enum_sources = [
  'ims-element-provider.h',
  #'ims-pipeline-addin.h',
  #'ims-router-addin.h',
]

# Generate enums for gobject typing
plugin_enums = gnome.mkenums('ims-enums',
         sources: enum_sources,
      c_template: 'ims-enums.c.template',
      h_template: 'ims-enums.h.template',
  install_header: true,
     install_dir: join_paths(get_option('includedir'), 'ims'),
)

dep_gdkpixbuf = dependency('gdk-pixbuf-2.0')

plugin_deps = [
  dep_gdkpixbuf,
  dep_peas,
  dep_valum,
]

# Fight meson race conditions..
libenum = static_library('enum', plugin_enums,
  dependencies: plugin_deps,
)

link_libenum = declare_dependency(
              sources: plugin_enums,
  include_directories: include_directories('.'),
)

plugin_sources = [
  'ims-plugin.c',
  'ims-element-provider.c',
  #'ims-pipeline-addin.c',
  #'ims-router-addin.c',
]

plugin_headers = [
  'ims-plugin.h',
  'ims-element-provider.h',
  #'ims-pipeline-addin.h',
  #'ims-router-addin.h',
]

plugin_deps += link_libenum

# build plugin
# TODO: Install the plugin library?
libplugin = shared_library('ims-plugin', plugin_sources,
  dependencies: plugin_deps,
       version: '0.0.0',
       install: false,
)

install_headers(plugin_headers, subdir: 'ims')

# Generate .gir
libplugin_gir = gnome.generate_gir(libplugin,
            sources: plugin_sources + plugin_headers + plugin_enums,
          namespace: 'ImsPlugin',
          nsversion: '@0@'.format(api_version),
       dependencies: plugin_deps,
           includes: [
             'GObject-2.0',
             'Gio-2.0',
             'Peas-1.0',
           ],
      symbol_prefix: 'ims',
  identifier_prefix: 'Ims',
            install: false,
         extra_args: [
           '--warn-all',
           '--c-include', 'ims.h',
           '--c-include', 'ims-plugin.h',
         ],
)

libplugin_vapi = gnome.generate_vapi('ims-plugin-@0@'.format(api_version),
   sources: [libplugin_gir[0]],
  packages: [ 'libpeas-1.0' ],
   install: true,
)

link_libplugin = declare_dependency(
            link_with: libplugin,
         dependencies: plugin_deps,
  include_directories: [ include_directories('.') ],
)

# Expose this directory to use with vapidir
dir_libplugin = meson.current_source_dir()
