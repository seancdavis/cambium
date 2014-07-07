class Admin.Views.Publishable extends Backbone.View

  el: 'body'

  initialize: =>
    @setupPickadate()

  setupPickadate: =>
    $('.active-date').pickadate()
    $('.inactive-date').pickadate()
    $('.active-time').pickatime()
    $('.inactive-time').pickatime()