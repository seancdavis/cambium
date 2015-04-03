class App.Views.DropdownMenu extends Backbone.View

  el: 'body'

  events:
    'click .dropdown-trigger': 'showDropdown'

  initialize: ->
    $(document).click(@checkHideDropdown)

  showDropdown: (e) ->
    e.preventDefault()
    $(e.target).closest('.dropdown-container').find('.dropdown-menu')
      .toggleClass('active')
    true

  checkHideDropdown: (e) ->
    if(
      !$(e.target).is('.dropdown-menu') &&
      !$(e.target).is('.dropdown-container') &&
      $(e.target).parents('.dropdown-container').length == 0
    )
      $('.dropdown-menu').removeClass('active')
    true
