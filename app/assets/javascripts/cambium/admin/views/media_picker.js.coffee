class App.Views.MediaPicker extends Backbone.View

  el: 'body'

  template: JST['cambium/admin/templates/modal']

  events:
    'click .media-picker .add': 'addMedia'
    'click .media-picker .remove': 'removeMedia'

  addMedia: (e) ->
    e.preventDefault()
    $.get $('#page-content').data('library'), (data) =>
      $('#modal-container').remove()
      $('body').prepend(@template(yield: data))
      $('article.tile').click (e2) =>
        e2.preventDefault()
        id = $(e2.target).parents('.tile').first().attr('data-id')
        filename = $(e2.target).parents('.tile').first().attr('data-filename')
        url = $(e2.target).parents('.tile').first().attr('data-url')
        thumb = $(e2.target).parents('.tile').first().attr('data-thumb')
        image = $(e2.target).parents('.tile').first().attr('data-image')
        $(e.target).siblings('input').first().val(id)
        $(e.target).siblings('a.file, img').remove()
        if image == 'true'
          $(e.target).parents('.media-picker').append("<img src=\"#{thumb}\">")
        $(e.target).parents('.media-picker').append """
          <a href="#{url}" class="file" target="_blank">#{filename}</a>
            """
        $(e.target).parents('.media-picker').find('a.remove').addClass('active')
        $('#modal-container').remove()

  removeMedia: (e) ->
    e.preventDefault()
    $(e.target).siblings('input').first().val('')
    $(e.target).siblings('img, a.file').remove()
    $(e.target).parents('.media-picker').find('a.remove').removeClass('active')
    $(e.target).siblings('input').first().val('')
