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
      @admin ||= Cambium::AdminPresenter.new
    end

  end
end
