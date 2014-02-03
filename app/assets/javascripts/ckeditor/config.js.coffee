CKEDITOR.editorConfig = (config) ->
  config.language = 'en'
  config.height = '600'
  config.toolbar_Pure = [ { name: 'document',    items: [ 'Source','-','Save','NewPage','DocProps','Preview','Print','-','Templates' ] },
  { name: 'clipboard',   items: [ 'Cut','Copy','Paste','PasteText','PasteFromWord','-','Undo','Redo' ] },
  { name: 'editing',     items: [ 'Find','Replace','-','SelectAll','-','SpellChecker', 'Scayt' ] },
  { name: 'tools',       items: [ 'Maximize', 'ShowBlocks','-','About' ] }
    '/',
  { name: 'basicstyles', items: [ 'Bold','Italic','Underline','Strike','Subscript','Superscript','-','RemoveFormat' ] },
  { name: 'paragraph',   items: [ 'NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote','CreateDiv','-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock','-','BidiLtr','BidiRtl' ] },
  { name: 'links',       items: [ 'Link','Unlink','Anchor' ] },
    '/',
  { name: 'styles',      items: [ 'Styles','Format','Font','FontSize' ] },
  { name: 'colors',      items: [ 'TextColor','BGColor' ] },
  { name: 'insert',      items: [ 'Image','Flash','Table','HorizontalRule','Smiley','SpecialChar','PageBreak' ] },
  ]

  config.toolbar_CMUSV_SIMPLE = [ { name: 'document',    items: [ 'Source' , 'Maximize'] },
  { name: 'clipboard',   items: [ 'Cut','Copy','Paste','PasteText','PasteFromWord','-','Undo','Redo' ] },
  { name: 'links',       items: [ 'Link','Unlink','Anchor' ] },
  { name: 'justify',     items: ['Outdent','Indent','-','Blockquote']}  ,
    '/',
  { name: 'styles',      items: [ 'Format' ] },

  { name: 'basicstyles', items: [ 'Bold','Italic','Underline','Strike','Subscript','Superscript','-','RemoveFormat' ] },
  { name: 'paragraph',   items: [ 'NumberedList','BulletedList', 'Table'] },

    '/',
  ]


  config.toolbar_CMUSV = [ { name: 'document',    items: [ 'Source' , 'Maximize'] },
  { name: 'clipboard',   items: [ 'Cut','Copy','Paste','PasteText','PasteFromWord','-','Undo','Redo', '-','SelectAll','RemoveFormat'] },
      '/',
  { name: 'paragraph',   items: [ 'Format', 'NumberedList','BulletedList','-','Outdent','Indent','Blockquote', 'Table', 'HorizontalRule'] },
  { name: 'basicstyles', items: [ 'Bold','Italic','Underline','Strike','Subscript','Superscript','-','RemoveFormat' ] },
  { name: 'links',       items: [ 'Link','Unlink','Anchor' ] },
      '/',

    ]

  config.toolbar = 'CMUSV'
  true



