ims_resources = gnome.compile_resources('ims-resources',
  'ims.gresource.xml',
  c_name: 'ims',
)

ims_sources = [
  'app.vala',
  'config.vala',
  'database.vala',
  'dbus.vala',
  'main.vala',
  'model.vala',
  'plugin-manager.vala',
  'pipeline-manager.vala',
  'router.vala',
  'routes/image.vala',
]

ims_deps += [
  link_libconfig,
  link_libims,
  link_libplugin,
  libplugin_vapi,
]

sources = [
  ims_resources,
  ims_sources,
]

executable(meson.project_name(), sources,
  dependencies: ims_deps,
     vala_args: ims_vala_args,
       install: true,
)
