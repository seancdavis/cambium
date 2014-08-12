#= require jquery
#= require jquery_ujs
#= require pickadate/picker
#= require pickadate/picker.date
#= require pickadate/picker.time
#= require admin/wysihtml5
#= require admin/parser_rules/custom
#= require underscore
#= require backbone
#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./collections
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
