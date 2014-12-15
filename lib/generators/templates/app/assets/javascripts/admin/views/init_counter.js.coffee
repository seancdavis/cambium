class Admin.Views.InitCounter extends Backbone.View

  el: 'form'

  initialize: =>
    @findMaxLengths()

  findMaxLengths: =>
    for input in $('input')
      if $(input).attr('maxlength')?
        new Admin.Views.Counter
          target: $(input).attr('id')
          max: $(input).attr('maxlength')
