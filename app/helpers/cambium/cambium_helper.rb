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

    def admin_view
      @admin_view ||= admin.view(controller_name)
    end

    def admin_table
      @admin_table ||= admin_view.table
    end

    def admin_form
      @admin_form ||= admin_view.form
    end

    def admin_routes
      @admin_routes ||= admin.routes(@object)
    end

    def cambium_page_title(title)
      content_tag(:div, :id => 'title-bar') do
        content_tag(:h2, title, :class => 'page-title')
      end
    end

    def cambium_table(collection, columns)
      obj_methods = []
      content_tag(:section, :class => 'data-table') do
        content_tag(:table) do
          o = content_tag(:thead) do
            content_tag(:tr) do
              o2 = ''
              columns.to_h.each do |col|
                obj_methods << col.first.to_s
                o2 += content_tag(:th, col.last.heading)
              end
              o2 += content_tag(:th, nil)
              o2.html_safe
            end
          end
          o += content_tag(:tbody) do
            o2 = ''
            collection.each do |obj|
              o2 += content_tag(:tr) do
                o3 = ''
                obj_methods.each do |method|
                  o3 += content_tag(:td, obj.send(method))
                end
                path = "edit_admin_#{controller_name.singularize}_path"
                if cambium.respond_to?(path.to_sym)
                  route = cambium.send(path, obj)
                else
                  route = main_app.send(path, obj)
                end
                o3 += content_tag(:td, link_to('', route), :class => 'actions')
                o3.html_safe
              end
            end
            o2.html_safe
          end
          o.html_safe
        end
      end
    end

    def cambium_form(obj, fields)
      content_tag(:section, :class => 'form') do
        simple_form_for [:admin, obj] do |f|
          o = ''
          fields.to_h.each do |data|
            attr = data.first.to_s
            options = data.last
            o += f.input(
              attr.to_sym,
              :as => options.type
            )
          end
          o += f.submit
          o.html_safe
        end
      end
    end

  end
end
