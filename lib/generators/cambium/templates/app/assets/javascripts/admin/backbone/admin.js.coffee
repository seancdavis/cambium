#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.Admin =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}

$(document).ready ->
  new Admin.Routers.Router

  # Enable pushState for compatible browsers
  enablePushState = true

  # Disable for older browsers
  pushState = !!(enablePushState && window.history && window.history.pushState)

  Backbone.history.start({ pushState: pushState })
