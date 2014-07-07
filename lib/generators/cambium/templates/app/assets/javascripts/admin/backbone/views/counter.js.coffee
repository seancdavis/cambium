class Admin.Views.Counter extends Backbone.View

  el: 'body'

  initialize: (options) =>
    @max = options.max
    @target = "##{options.target}"
    @setupCounter()
    @updateCounter()
    $(@target).keyup =>
      @updateCounter()

  setupCounter: =>
    $(@target).siblings('label').append """
      &nbsp;(<span class="maxlength">#{@max}</span>)
      """
    @counter = $(@target).siblings('label').children('.maxlength')

  updateCounter: =>
    charsRemaining = @max - $(@target).val().length
    $(@counter).html charsRemaining
    if charsRemaining > 10
      $(@counter).removeClass('warning')
    else
      $(@counter).addClass('warning')