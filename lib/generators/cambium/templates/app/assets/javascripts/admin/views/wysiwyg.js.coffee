class Admin.Views.Wysiwyg extends Backbone.View

  el: 'body'
  textarea: '.wysiwyg'

  initialize: (options) =>
    editor = new wysihtml5.Editor "wysihtml5-textarea", #textarea-id
      toolbar: "wysihtml5-toolbar" # id of toolbar element
      parserRules: wysihtml5ParserRules # defined in parser rules set
      stylesheets: [ WYSIWYG_BASE_STYLES, WYSIWYG_CUSTOM_STYLES ] # defined in admin.html.erb
