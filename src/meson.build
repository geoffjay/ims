subdir('config')

ims_resources = gnome.compile_resources('ims-resources',
  'ims.gresource.xml',
  c_name: 'ims',
)

ims_vala_args = [
  '--vapidir', dir_libconfig,
  '--pkg', 'ims-config',
]

ims_lib_sources = [
  'lib/image.vala',
  'lib/plugin.vala',
  'lib/pipeline.vala',
  'lib/pipeline-addin.vala',
  'lib/pipeline-element.vala',
  'lib/pipeline-manager.vala',
  'lib/router.vala',
  'lib/router-addin.vala',
]

# TODO: build internal library for testable classes

ims_sources = [
  'app.vala',
  'config.vala',
  'database.vala',
  'dbus.vala',
  'main.vala',
  'model.vala',
  'plugin-manager.vala',
  'routes/image.vala',
]

ims_deps += link_libconfig

ims_lib_reqs = [
  'gdk-3.0',
  'glib-2.0',
  'gio-2.0',
  'gee-0.8',
  'json-glib-1.0',
  'libpeas-1.0',
  'libsoup-2.4',
  'libxml-2.0',
  'valum-0.4',
  'vsgi-0.4',
]

ims_lib = library('ims-' + api_version, ims_lib_sources,
  dependencies: ims_deps,
   vala_header: 'ims.h',
     vala_args: ims_vala_args,
     vala_vapi: 'ims-@0@.vapi'.format(api_version),
      vala_gir: 'Ims-@0@.gir'.format(api_version),
       install: true,
   install_dir: [true, true, true, true],
)

g_ir_compiler = find_program('g-ir-compiler', required: false)
if g_ir_compiler.found()
  custom_target('IMS typelib',
        command: [
                    g_ir_compiler,
                    '--shared-library',
                    ims_lib.full_path(),
                    '--output', '@OUTPUT@',
                    join_paths(meson.current_build_dir(),
                    'Ims-@0@.gir'.format(api_version))
                 ],
         output: 'Ims-@0@.typelib'.format(api_version),
        depends: ims_lib,
        install: true,
    install_dir: join_paths(get_option('libdir'), 'girepository-1.0'),
  )
endif

pkgconfig = import('pkgconfig')
pkgconfig.generate(
    libraries: [ims_lib],
      subdirs: [ 'libims-@0@'.format(api_version) ],
      version: meson.project_version(),
         name: 'libims',
     filebase: 'libims-@0@'.format(api_version),
  description: 'Library to extend the image manipulation service',
     requires: ims_lib_reqs,
  install_dir: join_paths(pkg_libdir, 'pkgconfig'),
)

sources = [
  ims_resources,
  ims_sources,
  ims_lib_sources,
]

executable(meson.project_name(), sources,
  dependencies: ims_deps,
     vala_args: ims_vala_args,
       install: true,
)

ims = declare_dependency(
  include_directories: include_directories('.'),
            link_with: ims_lib,
)
