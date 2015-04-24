class App.Views.Pickadate extends Backbone.View

  el: 'body'

  initialize: ->
    $('input.pickadate').pickadate()
    $('input.pickatime').pickatime()
    if $('div.pickadatetime').length > 0
      $('input.pickadatetime-date').pickadate()
      $('input.pickadatetime-time').pickatime()
      $('input.pickadatetime-date, input.pickadatetime-time').change (e) ->
        parent = $(e.target).parents('div.pickadatetime').first()
        val = parent.find('input.pickadatetime-date').val()
        val = "#{val} #{parent.find('input.pickadatetime-time').val()}"
        $(e.target).siblings('input.pickadatetime').first().val(val)
