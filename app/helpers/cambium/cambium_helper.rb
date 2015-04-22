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
      @admin_table ||= admin_view.nil? ? nil : admin_view.table
    end

    def admin_form
      @admin_form ||= begin
        if action_name == 'new' || action_name == 'create'
          admin_view.form.new
        else
          admin_view.form.edit
        end
      end
    end

    def admin_routes
      @admin_routes ||= admin.routes(@object)
    end

    def admin_model
      @admin_model ||= admin_view.model.constantize
    end

    def cambium_page_title(title)
      content_tag(:div, :id => 'title-bar') do
        o  = content_tag(:h2, title, :class => 'page-title')
        if(
          !admin_table.nil? &&
          admin_table.buttons.new.present? &&
          action_name == 'index'
        )
          o += link_to(
            "New #{admin_model.to_s.humanize}",
            admin_routes.new,
            :class => 'button new'
          )
        end
        o.html_safe
      end
    end

    def cambium_table(collection, columns)
      obj_methods = []
      content_tag(:section, :class => 'data-table') do
        p = content_tag(:table) do
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
                begin
                  route = cambium.send(path, obj)
                rescue
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
        p += paginate(collection)
      end
    end

    def cambium_form(obj, fields)
      content_tag(:section, :class => 'form') do
        simple_form_for [:admin, obj] do |f|
          o = ''
          fields.to_h.each do |data|
            attr = data.first.to_s
            options = data.last
            if ['select','check_boxes','radio_buttons'].include?(options.type)
              o += f.input(
                attr.to_sym,
                :as => options.type,
                :collection => options.options
              )
            elsif ['date','time'].include?(options.type)
              if obj.send(attr).present?
                val = (options.type == 'date') ?
                  obj.send(attr).strftime("%d %B, %Y") :
                  obj.send(attr).strftime("%l:%M %p")
              end
              o += f.input(
                attr.to_sym,
                :as => :string,
                :input_html => {
                  :class => "picka#{options.type}",
                  :value => val.nil? ? nil : val
                }
              )
            elsif options.type == 'datetime'
              o += content_tag(:div, :class => 'input string pickadatetime') do
                o2 = content_tag(:label, attr.to_s.humanize.titleize)
                o2 += content_tag(
                  :input,
                  '',
                  :placeholder => 'Date',
                  :type => 'text',
                  :class => 'pickadatetime-date',
                  :value => obj.send(attr).present? ?
                    obj.send(attr).strftime("%d %B, %Y") : ''
                )
                o2 += content_tag(
                  :input,
                  '',
                  :placeholder => 'Time',
                  :type => 'text',
                  :class => 'pickadatetime-time',
                  :value => obj.send(attr).present? ?
                    obj.send(attr).strftime("%l:%M %p") : ''
                )
                o2 += f.input(
                  attr.to_sym,
                  :as => :hidden,
                  :wrapper => false,
                  :label => false,
                  :input_html => { :class => 'pickadatetime' }
                )
              end
            else
              o += f.input(
                attr.to_sym,
                :as => options.type
              )
            end
          end
          o += f.submit
          o.html_safe
        end
      end
    end

    def cambium_search_route(obj)
      controller = obj.class.to_s.humanize.singularize.downcase
      path = "admin_#{controller}_path"
      begin
        link_to('', cambium.send(path, obj))
      rescue
        link_to('', main_app.send(path, obj))
      end
    end

  end
end
