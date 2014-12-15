class Admin.Routers.Router extends Backbone.Router

  initialize: =>
    @autoLoad()

  autoLoad: =>
    if $(".wysihtml5").length > 0
      for wysiwyg in $(".wysihtml5")
        console.log 'wysihtml5'
        new Admin.Views.Wysiwyg
          id: $(wysiwyg).children('textarea').attr('id')
          toolbarID: $(wysiwyg).siblings('.wysihtml5-toolbar').attr('id')
          image_upload: true
          url: "/admin/json/images"
    new Admin.Views.Publishable if $("[class*=_active_date]").length > 0
    new Admin.Views.InitCounter if $('input').length > 0
    new Admin.Views.Paginator if $('table').length > 0
    new Admin.Views.DropdownToggle if $('.dropdown-toggle').length > 0
    new Admin.Views.Accordion if $('.accordion').length > 0

  routes:
    'admin': 'initAdmin'
    "admin/posts": "initPosts"
    "admin/posts/new": "initNewPost"
    "admin/posts/:id/edit": "initEditPost"

  initAdmin: =>
    console.log "Welcome to your CMS, powered by Ruby on Rails and Cambium!"

  initEditPost: (id) =>
    new Admin.Views.Tags
      id: id
      taggable: "Post"
      url: "/admin/json/posts/#{id}/taggings"

  initNewPost: =>
    $('#tag-container').closest('.fields').hide()