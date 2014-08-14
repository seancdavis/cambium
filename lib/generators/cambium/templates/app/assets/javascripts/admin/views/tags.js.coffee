class Admin.Views.Tags extends Backbone.View

  el: "#tag-container"

  dup: false
  active: 0

  template: JST['admin/templates/tag']

  events:
    "keyup #new-tag-title": "keyController"
    "keydown #new-tag-title": "checkEnter"
    "click .delete-tag": "deleteTag"
    "click a.autocomplete": "addAutocomplete"
    
  # ------------------------------------------- init

  initialize  : (options) =>
    @setOptions options
    @collection = new Admin.Collections.Tags @url
    @fetchTags()
    $('body').click (e) =>
      unless $(e.target).hasClass('deleteTag') or $(e.target).hasClass('autocomplete') or $(e.target).hasClass('new-tag-title')
        $('ul.autocomplete').html ""

  setOptions: (options) =>
    if options.id
      @url = options.url
      @taggable = options.taggable
      @taggable_id = options.id

  # ------------------------------------------- get data
  
  fetchTags: =>
    @collection.fetch
      success: (tags) =>
        @tags = tags.toJSON()
        @renderTags()
        @getAllTags()
        
  getAllTags: =>
    $.ajax
      url: "/admin/json/tags"
      success: (data) =>
        @allTags = new Array()
        @currentTags = new Array()
        @currentTags.push($(tag).html()) for tag in $('#tag-list li > span.title')
        for tag in data
          @allTags.push tag.name if @currentTags.indexOf(tag.name) is -1

  # ------------------------------------------- render
  
  renderTags: =>
    $(".loading").html ""
    $("#tag-list").html ""
    _.each @tags, (tag) =>
      @renderTag(tag) if `tag.title != undefined`

  renderTag: (tag) =>
    $('#tag-list').append @template
      id: tag.id
      tag_id: tag.tag_id
      title: tag.title

  # ------------------------------------------- events controller
  
  keyController: (e) =>
    e.preventDefault()
    title = $(e.target).val()
    if title == ""
      @reset()
    else
      switch e.keyCode
        # when 13 then @checkDuplicates(title) # Enter
        when 38 # Up Arrow
          if @active != 0
            @active--
            if @active == 0
              $("#new-tag-title").val @origVal
            else
              @updateVal(title)
        when 40 # Down Arrow
          @origVal = title if @active == 0
          @active++ if @active != @maxAutocomplete
          @updateVal(title)
        else
          @autocomplete(title)

  checkEnter: (e) =>
    $('div.tagging-errors').html ""
    if e.keyCode == 13
      e.preventDefault()
      @splitTitle( $(e.target).val() )
      # @checkDuplicates( $(e.target).val() )
  
  # ------------------------------------------- autocomplete
  
  updateVal: (title) =>
    $('ul.autocomplete li').removeClass "active"
    $("li#arrow-#{@active}").addClass "active"
    $("#new-tag-title").val( $("#arrow-#{@active} > a").html() )
  
  reset: =>
    @active = 0
    $('#new-tag-title').val ""
    $('ul.autocomplete').html ""

  autocomplete: (title) =>
    $('ul.autocomplete').html ""
    if `title != ""`
      arrow = 1
      console.log @allTags
      for tag in @allTags
        if tag.toLowerCase().indexOf(title.toLowerCase()) > -1
          $('ul.autocomplete').append "<li id=\"arrow-#{arrow}\"><a class=\"autocomplete\" href=\"#\">#{tag}</a></li>"
          arrow++
      @maxAutocomplete = arrow - 1
  
  addAutocomplete: (e) =>
    e.preventDefault()
    title = $(e.target).html()
    @newTag(title)
    $('ul.autocomplete').html ""

  splitTitle: (str) =>
    titles = str.split(', ')
    for t in titles
      @checkDuplicates(t)
    
  checkDuplicates: (title) =>
    for li in $('#tag-list li')
      @dup = true if title.toLowerCase() == $(li).data("title").toLowerCase()
    if @dup is true
      $('div.tagging-errors').append "You already have the tag: #{title}<br>"
      # @reset()
      @dup = false
    else if `title != ""`
      @newTag(title)
    
  # ------------------------------------------- CRUD

  newTag: (title) =>
    model = new Admin.Models.Tag
      tag_title: title
      taggable: @taggable
      taggable_id: @taggable_id
    model.save null,
      complete: (model, response) =>
        @fetchTags()
        @reset()

  deleteTag: (e) =>
    e.preventDefault()
    id = $(e.target).parents('li').data('id')
    model = @collection.get(id)
    model.destroy()
    $(e.target).parents('li').next('.separator').remove()
    $(e.target).parents('li').remove()
