CKEDITOR.editorConfig = (config) ->



  config.toolbar_CMUSV_SIMPLE = [ { name: 'document',    items: [ 'Source' , 'Maximize'] },
  { name: 'clipboard',   items: [ 'Cut','Copy','Paste','PasteText','PasteFromWord','-','Undo','Redo' ] },
  { name: 'links',       items: [ 'Link','Unlink','Anchor' ] },
  { name: 'justify',     items: ['Outdent','Indent','-','Blockquote', '-', 'Format']}  ,
    '/',
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



