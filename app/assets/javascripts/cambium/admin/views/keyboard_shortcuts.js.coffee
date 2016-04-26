class App.Views.KeyboardShortcuts extends Backbone.View

  el: 'body'

  events:
    'keyup': 'shortcut'

  shortcut: (e) ->
    switch e.keyCode
      when 27 # Esc
        $('.search-box input').blur()
      when 78 # n
        if $('#title-bar .button.new').length > 0
          window.location = $('#title-bar .button.new').first().attr('href')
      when 111, 191 # /
        $('.search-box input').focus()
