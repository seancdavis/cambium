class Admin.Routers.Router extends Backbone.Router

  initialize: =>
    @autoLoad()

  autoLoad: =>
    if $(".wysihtml5").length > 0
      for wysiwyg in $(".wysihtml5")
        new Admin.Views.Wysiwyg
          id: $(wysiwyg).children('textarea').attr('id')
          toolbarID: $(wysiwyg).siblings('.wysihtml5-toolbar').attr('id')
    new Admin.Views.Publishable if $("[class*=_active_date]").length > 0
    new Admin.Views.InitCounter if $('input').length > 0
    new Admin.Views.Paginator if $('table').length > 0
    new Admin.Views.DropdownToggle if $('.dropdown-toggle').length > 0
    new Admin.Views.Accordion if $('.accordion').length > 0
