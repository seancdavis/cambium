class App.Views.Editor extends Backbone.View

  initialize: ->
    for textarea in $('textarea.editor')
      $(textarea).trumbowyg
        fullscreenable: false
        btns: ['viewHTML',
          '|', 'formatting',
          '|', 'strong', 'em',
          '|', 'link',
          '|', 'insertImage',
          '|', 'justifyLeft', 'justifyCenter',
          '|', 'btnGrp-lists',
          '|', 'horizontalRule']
