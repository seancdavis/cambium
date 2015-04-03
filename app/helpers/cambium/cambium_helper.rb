module Cambium
  module CambiumHelper

    def not_found
      raise ActionController::RoutingError.new('Not Found')
    end

    def avatar(user, size = 100, klass = nil)
      gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
      content_tag(:div, :class => "avatar-container #{klass}") do
        image_tag "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}&d=mm",
          :class => 'avatar'
      end
    end

    def admin
      @admin ||= Cambium::AdminPresenter.new(self)
    end

    def cambium_page_title(title)
      content_tag(:div, :id => 'title-bar') do
        content_tag(:h2, title, :class => 'page-title')
      end
    end

  end
end
