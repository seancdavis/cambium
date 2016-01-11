class App.Views.MediaPicker extends Backbone.View

  el: 'body'

  template: JST['cambium/admin/templates/modal']

  events:
    'click .media-picker .add': 'addMedia'

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
        $(e.target).siblings('input').first().val(id)
        $(e.target).siblings('a.file, img').remove()
        $(e.target).after """
          <a href="#{url}" class="file" target="_blank">#{filename}</a>
            """
        $('#modal-container').remove()
