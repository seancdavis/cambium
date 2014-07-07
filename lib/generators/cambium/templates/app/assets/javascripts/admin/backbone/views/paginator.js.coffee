class Admin.Views.Paginator extends Backbone.View

  el: 'table'
  group: 15
  current: 1
  next: 2

  controls: JST['admin/backbone/templates/paginator_controls']
  paginav: JST['admin/backbone/templates/paginator_nav']

  initialize: =>
    @setup()
    @bindEvents()

  setup: =>
    for submission, i in $('tbody tr') by @group
      $('tbody tr').slice(i, i + @group).attr('data-group', Math.floor(i / @group) + 1)
    $("tbody tr[data-group='1']").show()
    @max = $('tbody tr').last().data('group')
    @prev = @max
    if $("tbody tr[data-group='2']").length > 0
      $(@el).before @controls
      $(@el).after @paginav
      $('.paginav .total').html @max
    $(@el).addClass('active')

  bindEvents: =>
    @previousButton = $('.controls .prev').first()
    @previousButton.hide()
    @nextButton = $('.controls .next').first()
    @previousButton.click (e) =>
      e.preventDefault()
      @goBack()
    @nextButton.click (e) =>
      e.preventDefault()
      @goForward()
    if $("tbody tr[data-group='2']").length > 0
      $('#jump-to').click (e) =>
        e.preventDefault()
        page = $('#jump-to-val').val()
        @jumpTo(page) if page != '' and page <= @max
      $('#jump-to-val').keyup (e) =>
        e.preventDefault()
        $("#jump-to").click() if e.keyCode == 13

  goForward: =>
    $("tbody tr[data-group='#{@current}']").hide()
    $("tbody tr[data-group='#{@next}']").show()
    @prev = @current
    @current = @next
    if @next == @max
      @next = 1
    else
      @next++
    @updatePaginav()

  goBack: =>
    $("tbody tr[data-group='#{@current}']").hide()
    $("tbody tr[data-group='#{@prev}']").show()
    @next = @current
    @current = @prev
    if @prev == 1
      @prev = @max
    else
      @prev--
    @updatePaginav()

  updatePaginav: =>
    $('.paginav .current').html @current
    @previousButton.hide() if @current == 1
    @previousButton.fadeIn() if @current == 2
    @nextButton.hide() if @current == @max
    @nextButton.fadeIn() if @next == @max

  jumpTo: (page) =>
    $('#jump-to-val').val('')
    $("tbody tr[data-group='#{@current}']").hide()
    $("tbody tr[data-group='#{page}']").show()
    @current = page
    if @current == @max
      @next = 1
      @prev = @current - 1
    else if @current == 1
      @prev = @max
      @next = 2
    @updatePaginav()
