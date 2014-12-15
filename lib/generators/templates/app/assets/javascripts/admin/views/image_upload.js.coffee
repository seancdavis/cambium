class Admin.Views.ImageUpload extends Backbone.View

  el: "body"

  # events:
  #   "click form.edit_project input[type=submit]": "submitForm"

  initialize: (options) =>
    @model = options.model
    $("form.edit_#{@model} input[type=submit]").click @submitForm
    $("#image_filename").attr "name", "image[filename]"
    $(".images-container").after ->
      $("#new_image").clone()
      $(".new_image").last().remove()
    $("#new_image").fileupload
      add: (e,data) ->
        $(".images-container").append """
          <div class="loading">Uploading #{data.files[0].name}...</div>
            """
        data.submit()
      complete: (e,data) ->
        $(".images-container div.loading").first().remove()
        $(".images-container div.loading").insertAfter( $(".images-container img").last() )

  submitForm: (e) =>
    e.preventDefault()
    $("#new_image").remove()
    $("form.edit_#{@model}").submit()
