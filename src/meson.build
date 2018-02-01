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
  'lib/router.vala',
  'lib/router-addin.vala',
]

# TODO: build internal library for testable classes

ims_sources = [
  'app.vala',
  'config.vala',
  'database.vala',
  'main.vala',
  'model.vala',
  'plugin-manager.vala',
  'routes/image.vala',
]

ims_deps += link_libconfig

ims_lib = shared_library(meson.project_name(), ims_lib_sources,
  dependencies: ims_deps,
   vala_header: 'ims.h',
     vala_args: ims_vala_args,
       install: true,
   install_dir: pkg_libdir,
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
