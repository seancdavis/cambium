class Admin.Views.Wysiwyg extends Backbone.View

  el: 'body'
  textarea: '.wysiwyg'
  modal: '#wysihtml5-insert-image-modal'
  imagesContainer: 'div.images-container'

  imageTemplate: JST['admin/templates/image']

  events:
    'click a.browse-images': 'initInsertImage'

  initialize: (options) =>
    @initEditor(options)
    options.image_upload = true if typeof(options.image_upload) == undefined
    if options.image_upload == true
      @renderInsertImageModal()
      @collection = new Admin.Collections.Images options.url
      @fetchImages()
      @initImageUpload()
    else
      $('a.browse-images').hide()

  initEditor: (options) =>
    editor = new wysihtml5.Editor options.id, #textarea-id
      toolbar: options.toolbarID # id of toolbar element
      parserRules: wysihtml5ParserRules # defined in parser rules set
      stylesheets: [ WYSIWYG_BASE_STYLES, WYSIWYG_CUSTOM_STYLES ] # defined in admin.html.erb

  fetchImages: =>
    @collection.fetch
      success: (images) =>
        @images = images.toJSON()
        @renderImages()
        $("#{@imagesContainer} img").click (e) =>
          $('input.insert-image').val window.location.origin+$(e.target).data('src')
          @closeModal()

  renderImages: =>
    $(@imagesContainer).html ""
    if @images.length > 0
      _.each @images, (image) =>
        if image.filename
          $(@imagesContainer).append @imageTemplate(image: image)

  renderInsertImageModal: =>
    $(window).resize(@positionInsertImageModal)
    $("#{@modal} .modal a.close").click @closeModal

  closeModal: =>
    $(@modal).hide()
    $(@el).css
      overflow: 'auto'
      height: 'auto'

  initInsertImage: (e) =>
    $(@el).css
      overflow: 'hidden'
      height: '100%'
    @fetchImages()
    @positionInsertImageModal()
    $(@modal).show()

  positionInsertImageModal: =>
    ww = $(window).width()
    wh = $(window).height()
    left = ( ww / 2 ) - 331
    top = ( wh / 2 ) - 200
    $("#{@modal} .modal").css
      top: "#{top}px"
      left: "#{left}px"

  initImageUpload: =>
    $("#image_filename").attr "name", "image[filename]"
    $("#new_image").fileupload
      add: (e,data) ->
        $(".images-container").prepend """
          <div class="loading">Uploading #{data.files[0].name}...</div>
            """
        data.submit()
      complete: (e,data) =>
        @fetchImages()
        $(".images-container div.loading").first().remove()
        # $(".images-container div.loading").insertBefore( $(".images-container img").first() )
        $(".images-container img").click (e) =>
          $('input.insert-image').val $(e.target).data('src')
          @closeModal()
