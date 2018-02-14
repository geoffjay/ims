save_sources = [
  'save.vala',
  'pipeline-addin.vala',
]

save_deps = ims_deps + [ ims ]
save_vala_args = [ ims_vala_args ]

shared_module('save', save_sources,
  dependencies: save_deps,
     vala_args: save_vala_args,
       install: true,
   install_dir: pkg_plugindir,
)

install_data(
      sources: 'save.plugin',
  install_dir: pkg_plugindir,
)
