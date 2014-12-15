class Admin.Models.Tag extends Backbone.Model

  urlRoot: "/admin/json/taggings"

class Admin.Collections.Tags extends Backbone.Collection

  model: Admin.Models.Tag

  initialize: (url) =>
    @url = url

  comparator: (tag) ->
    if tag.get("title")
      return tag.get("title").toLowerCase()
