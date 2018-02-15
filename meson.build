project('ims', [ 'c', 'vala' ],
          license: 'LGPL3+',
          version: '0.1.0',
    meson_version: '>= 0.40.1',
  default_options: [
                     'c_std=gnu11',
                     'warning_level=2',
                   ],
)

version_split = meson.project_version().split('.')
MAJOR_VERSION = version_split[0]
MINOR_VERSION = version_split[1]
MICRO_VERSION = version_split[2]

api_version = '1.0'

status = [
  '', '',
  'Image Manipulation Service @0@'.format(meson.project_version()),
  '', '',
]

# Warning message
if (version_split[1].to_int() % 2 == 1)
  status += [
    'You are building a debug version of ims. There may be more bugs in',
    'this version that you are comfortable with.',
    '', ''
  ]
endif

status += [
  'Version ............................... : @0@'.format(meson.project_version()),
  'Build Type ............................ : @0@'.format(get_option('buildtype')),
  '',
  'Prefix ................................ : @0@'.format(get_option('prefix')),
  'Libdir ................................ : @0@'.format(join_paths(get_option('prefix'), get_option('libdir'))),
  '', ''
]

am_cflags = [
  '-fstack-protector',
  '-fPIC',
  '-pedantic',
  '-Wstrict-prototypes',
  '-Wundef',
  '-Werror-implicit-function-declaration',
  '-Wformat',
  '-Wformat-security',
  '-Werror=format-security',
  '-Wconversion',
  '-Wunused-variable',
  '-Wunreachable-code',
  '-Wall',
  '-W',
]

add_global_arguments(am_cflags, language: 'c')

add_project_arguments([
  ['--vapidir', join_paths(meson.current_source_dir(), 'vapi')],
], language: 'vala')

dep_glib = dependency('glib-2.0')
dep_gobject = dependency('gobject-2.0')
dep_gio = dependency('gio-2.0')
dep_gda = dependency('libgda-5.0')
dep_gdk = dependency('gdk-3.0')
dep_gee = dependency('gee-0.8')
dep_json = dependency('json-glib-1.0')
dep_peas = dependency('libpeas-1.0')
dep_soup = dependency('libsoup-2.4')
dep_xml = dependency('libxml-2.0')
dep_valum = dependency('valum-0.4', version: '>= 0.4.0')
dep_vsgi = dependency('vsgi-0.4', version: '>= 0.4.0')

dep_posix = meson.get_compiler('vala').find_library('posix')

ims_deps = [
  dep_glib,
  dep_gobject,
  dep_gio,
  dep_gda,
  dep_gdk,
  dep_gee,
  dep_json,
  dep_peas,
  dep_soup,
  dep_xml,
  dep_valum,
  dep_vsgi,
  dep_posix,
]

# Substitutions for various .in files
subst = configuration_data()

# Installation paths
pkg_datadir = join_paths(get_option('prefix'), get_option('datadir'), meson.project_name())
pkg_libdir = join_paths(get_option('prefix'), get_option('libdir'))
pkg_sysconfdir = join_paths(get_option('sysconfdir'), meson.project_name())
pkg_plugindir = join_paths(get_option('prefix'), get_option('libdir'), meson.project_name(), 'plugins')
pkg_typelibdir = join_paths(get_option('libdir'), 'girepository-1.0')

subst.set('bindir', join_paths(get_option('prefix'), get_option('bindir')))
subst.set('datadir', pkg_datadir)
subst.set('sysconfdir', pkg_sysconfdir)
subst.set('plugindir', pkg_plugindir)

# Create config.h
conf = configuration_data()

conf.set_quoted('PACKAGE_NAME', meson.project_name())
conf.set_quoted('PACKAGE_VERSION', meson.project_version())
conf.set_quoted('PACKAGE_STRING', '@0@-@1@'.format(meson.project_name(), meson.project_version()))
conf.set_quoted('PACKAGE_URL', 'https://github.com/geoffjay/ims')

conf.set_quoted('DATADIR', pkg_datadir)
conf.set_quoted('SYSCONFDIR', pkg_sysconfdir)
conf.set_quoted('PLUGINDIR', pkg_plugindir)

# For i18n
conf.set_quoted('GETTEXT_PACKAGE', meson.project_name())

# Write config.h
configure_file(
         output: 'config.h',
  configuration: conf,
)

# Enable other sections to find config.h
extra_includes = [
  include_directories('.'),
]

gnome = import('gnome')

subdir('src')
subdir('plugins')
subdir('data')
subdir('doc')
subdir('tests')

if get_option('enable-systemd')
  meson.add_install_script('build-aux/meson/meson-post-install.sh')
endif

message('\n'.join(status))
