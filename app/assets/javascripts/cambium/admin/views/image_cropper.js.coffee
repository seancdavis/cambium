class App.Views.ImageCropper extends Backbone.View

  el: 'body'

  template: JST['cambium/admin/templates/image_cropper']

  events:
    'click .image-actions a.crop': 'openModal'

  openModal: (e) ->
    e.preventDefault()
    data =
      url: $(e.target).data('url')
      width: $(e.target).data('width') / 3
      height: $(e.target).data('height') / 3
    $('#modal-container').remove()
    $('body').prepend(@template(image: data))
    $('#modal-container img').on 'load', () ->
      $('#modal-container .gravity div')
        .height($('#modal-container img').height() / 3)
    $('#modal-container .gravity div').click (event) =>
      e.preventDefault()
      $(e.target).parents('.image-actions').find('input')
        .val($(event.target).attr('data-gravity'))
      $('#modal-container').remove()
    $(document).keyup (e) ->
      $('#modal-container').remove() if e.keyCode == 27
