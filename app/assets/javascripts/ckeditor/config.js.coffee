CKEDITOR.editorConfig = (config) ->
  config.width = '600'


  config.toolbar_CMUSV_SIMPLE = [ { name: 'document',    items: [ 'Source' , 'Maximize'] },
  { name: 'clipboard',   items: [ 'Cut','Copy','Paste','PasteText','PasteFromWord', 'RemoveFormat' ] },
  { name: 'links',       items: [ 'Link','Unlink','Anchor','-', 'Outdent','Indent','Blockquote' ] },
    '/',
  { name: 'basicstyles', items: [ 'Format', 'Bold','Italic','Underline','Strike','Subscript','Superscript' ] },
  { name: 'paragraph',   items: [ 'NumberedList','BulletedList', 'Table'] },
    '/',
  ]


  config.toolbar_CMUSV = [ { name: 'document',    items: [ 'Source' , 'Maximize'] },
  { name: 'clipboard',   items: [ 'Cut','Copy','Paste','PasteText','PasteFromWord','-','Undo','Redo', '-','SelectAll','RemoveFormat'] },
  { name: 'links',       items: [ 'Link','Unlink','Anchor' ] },
      '/',
  { name: 'paragraph',   items: [ 'Format', 'NumberedList','BulletedList','-','Outdent','Indent','Blockquote', 'Table', 'HorizontalRule'] },
  { name: 'basicstyles', items: [ 'Bold','Italic','Underline','Strike','Subscript','Superscript','-','RemoveFormat' ] },
      '/',
    ]

  if window.location.href.indexOf("pages") != -1
      config.toolbar = 'CMUSV'
  else
      config.toolbar = 'CMUSV_SIMPLE'
  true



