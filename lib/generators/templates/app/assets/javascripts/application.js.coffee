#= require jquery
#= require jquery_ujs
#= require underscore
#= require backbone
#= require self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./views
#= require_tree ./routers

window.App =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}

$ ->
  new App.Routers.Router

  # Enable pushState for compatible browsers
  enablePushState = true

  # Disable for older browsers
  pushState = !!(enablePushState && window.history && window.history.pushState)

  Backbone.history.start({ pushState: pushState })
