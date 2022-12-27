quicknote_sources = [
  'main.vala',
  'application.vala',
  'window.vala',
  'note-window.vala',
  'note-widgets/toolbar/toolbar.vala'
]

quicknote_deps = [
  dependency('gtk4'),
  dependency('libadwaita-1'),
]

quicknote_sources += gnome.compile_resources('quicknote-resources',
  'quicknote.gresource.xml',
  c_name: 'quicknote'
)

executable('quicknote', quicknote_sources,
  dependencies: quicknote_deps,
       install: true,
)
