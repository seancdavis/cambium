class Admin.Routers.Router extends Backbone.Router

  initialize: =>
    @autoLoad()

  autoLoad: =>
    new Admin.Views.Wysiwyg if $(".wysihtml5").length > 0
    new Admin.Views.Publishable if $("[class*=_active_date]").length > 0
    new Admin.Views.InitCounter if $('input').length > 0
    new Admin.Views.Paginator if $('table').length > 0
    new Admin.Views.DropdownToggle if $('.dropdown-toggle').length > 0
    new Admin.Views.Accordion if $('.accordion').length > 0
