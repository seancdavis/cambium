class App.Routers.Router extends Backbone.Router

  initialize: =>
    @autoLoadClass()

  autoLoadClass: =>
    # This is a good place to automatically load classes that may be dependent
    # on a page element, and not necessarily the route.
    # 
    # For example:
    # 
    # new App.Views.Nav if $('.main-nav').length > 0
    # 
    # Or, perhaps you need to load a class on every page. Do that, here, too,
    # like this:
    # 
    new App.Views.DefaultHelpers

  routes:
    '': 'initHomePage'

  initHomePage: ->
    console.log "Welcome to this awesome site, built using Cambium!"
