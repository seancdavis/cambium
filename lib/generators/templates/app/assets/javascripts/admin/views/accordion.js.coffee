class Admin.Views.Accordion extends Backbone.View

  el: '.accordion'

  events:
    "click a.arrow": "toggleSlide"

  initialize: =>
    for el in $('.accordion')
      $(el).children('header').append """
        <a class="arrow" href="#">
          <i class="icon icon-arrow-up"></i>
        </a>
          """
      if $(el).hasClass('closed')
        $(el).find('.arrow i').toggleClass "icon-arrow-up"
        $(el).find('.arrow i').toggleClass "icon-arrow-down"
        $(el).find('.fields').hide()

  toggleSlide: (e) =>
    e.preventDefault()
    acc = $(e.target).parents('.accordion')
    acc.toggleClass "closed"
    if acc.hasClass "closed"
      acc.children('.fields').slideUp()
    else
      acc.children('.fields').slideDown()
    if $(e.target).children('.icon').length == 0
      $(e.target).toggleClass "icon-arrow-up"
      $(e.target).toggleClass "icon-arrow-down"
    else
      $(e.target).children('.icon').toggleClass "icon-arrow-up"
      $(e.target).children('.icon').toggleClass "icon-arrow-down"
