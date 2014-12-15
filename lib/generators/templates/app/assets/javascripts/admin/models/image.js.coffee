class Admin.Models.Image extends Backbone.Model

  urlRoot: "/admin/json/images"

class Admin.Collections.Images extends Backbone.Collection

  model: Admin.Models.Image

  initialize: (url) =>
    @url = url

  # comparator: (image) ->
  #   if image.get("sort")
  #     return image.get("sort")
