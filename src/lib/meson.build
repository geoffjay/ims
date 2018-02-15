subdir('plugin')

libims_sources = [
  'image.vala',
  'element.vala',
  'pipeline.vala',
  'router.vala',
  'plugin/ims-plugin.c',
]

libims_headers = [
  'plugin/ims-plugin.h',
]

libims_reqs = [
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

libims_vala_args = ims_vala_args + [
  '--vapidir', join_paths(meson.current_source_dir(), 'plugin'),
  '--pkg', 'ims-plugin',
]

libims = library('ims-' + api_version, libims_sources + libims_headers,
  dependencies: ims_deps,
   vala_header: 'ims.h',
     vala_args: libims_vala_args,
     vala_vapi: 'ims-@0@.vapi'.format(api_version),
       install: true,
   install_dir: [true, true, true],
)

###

gnome = import('gnome')
libims_gir = gnome.generate_gir(libims,
            sources: libims_sources + libims_headers,
          namespace: 'Ims',
          nsversion: '@0@'.format(api_version),
       dependencies: ims_deps,
           includes: [
             'GObject-2.0',
             'Gio-2.0',
             'Gdk-3.0',
             'Peas-1.0',
           ],
      symbol_prefix: 'ims',
  identifier_prefix: 'Ims',
            install: true,
         extra_args: [
           '--warn-all',
           '--c-include', 'ims.h',
           '--c-include', 'plugin/ims-plugin.h',
         ],
)

#libims_vapi = gnome.generate_vapi('ims-plugin-@0@'.format(api_version),
   #sources: [libims_gir[0]],
  #packages: [ 'libpeas-1.0' ],
   #install: true,
#)

###

#g_ir_compiler = find_program('g-ir-compiler', required: false)
#if g_ir_compiler.found()
  #custom_target('IMS typelib',
        #command: [
                    #g_ir_compiler,
                    #'--shared-library',
                    #libims.full_path(),
                    #'--output', '@OUTPUT@',
                    #join_paths(meson.current_build_dir(), 'Ims-@0@.gir'.format(api_version))
                 #],
         #output: 'Ims-@0@.typelib'.format(api_version),
        #depends: libims,
        #install: true,
    #install_dir: pkg_typelibdir,
  #)
#endif

pkgconfig = import('pkgconfig')
pkgconfig.generate(
    libraries: [libims],
      subdirs: [ 'libims-@0@'.format(api_version) ],
      version: meson.project_version(),
         name: 'libims',
     filebase: 'libims-@0@'.format(api_version),
  description: 'Library to extend the image manipulation service',
     requires: libims_reqs,
  install_dir: join_paths(pkg_libdir, 'pkgconfig'),
)

link_libims = declare_dependency(
            link_with: libims,
         dependencies: ims_deps,
  include_directories: [ include_directories('.') ],
)

# Expose this directory to use with vapidir
dir_libims = meson.current_source_dir()
