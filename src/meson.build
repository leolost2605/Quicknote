quicknote_sources = [
  'main.vala',
  'application.vala',
  'note-manager/window.vala',
  'note-window/note-window.vala',
  'note-widgets/toolbar/toolbar.vala',
  'lib/note.vala',
  'note-widgets/note-with-toolbar.vala',
  'lib/parser.vala',
  'lib/notebook.vala',
  'note-manager/notebook-page/notebook-page.vala',
  'note-manager/note-viewer/note-viewer.vala'
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
