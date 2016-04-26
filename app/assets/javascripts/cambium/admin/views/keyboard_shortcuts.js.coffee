class App.Views.KeyboardShortcuts extends Backbone.View

  el: 'body'

  events:
    'keyup': 'shortcut'

  shortcut: (e) ->
    switch e.keyCode
      when 27
        $('.search-box input').blur()
      when 111, 191
        $('.search-box input').focus()
