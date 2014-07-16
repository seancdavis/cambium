class Admin.Views.DropdownToggle extends Backbone.View

  el: '.dropdown-toggle'

  events:
    'click .trigger': 'initClick'

  initClick: (e) =>
    e.preventDefault()
    if $(e.target).hasClass('trigger')
      trigger = $(e.target)
    else
      trigger = $(e.target).parents('.trigger')
    trigger.toggleClass('active')
    trigger.children('i').toggleClass('icon-arrow-down icon-arrow-up')
    trigger.siblings('ul').toggle()