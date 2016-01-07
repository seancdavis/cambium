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
        if is_index? && has_new_form?
          o += link_to(
            admin_view.form.new.title,
            admin_routes.new,
            :class => 'button new'
          )
        end
        if is_index? && admin_view.export.present?
          o += link_to(
            admin_view.export.button || "Export #{admin_table.title}",
            "#{admin_routes.index}.csv",
            :class => 'button export'
          )
        end
        if is_edit? && can_delete?
          o += link_to(
            admin_view.form.buttons.delete,
            admin_routes.delete,
            :class => 'button delete',
            :method => :delete,
            :data => { :confirm => 'Are you sure?' }
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

    def cambium_form(obj, fields, url=nil, &block)
      content_tag(:section, :class => 'form') do
        if url.nil?
          case action_name
          when 'edit', 'update'
            url = cambium_route(:show, obj)
          else
            url = cambium_route(:index, obj)
          end
        end
        simple_form_for obj, :url => url do |f|
          o  = cambium_form_fields(f, obj, fields)
          o += capture(f, &block) if block_given?
          o += f.submit
          o
        end
      end
    end

    def cambium_form_fields(f, obj, fields)
      o = ''
      fields.to_h.each do |field|
        o += cambium_field(f, obj, field)
      end
      o.html_safe
    end

    def cambium_field(f, obj, field)
      attr = field.first.to_s
      options = field.last
      options = options.to_ostruct unless options.class == OpenStruct
      readonly = options.readonly || false
      label = options.label || attr.titleize
      if options.type == 'heading'
        content_tag(:h2, options.label || attr.titleize)
      elsif ['select','check_boxes','radio_buttons'].include?(options.type)
        parts = options.options.split('.')
        if parts.size > 1
          collection = parts[0].constantize.send(parts[1])
        else
          collection = options.options
        end
        f.input(attr.to_sym, :as => options.type, :collection => collection,
                :label => label, :readonly => readonly)
      elsif ['date','time'].include?(options.type)
        if obj.send(attr).present?
          val = (options.type == 'date') ?
            obj.send(attr).strftime("%d %B, %Y") :
            obj.send(attr).strftime("%l:%M %p")
        end
        f.input(attr.to_sym, :as => :string, :label => label,
                :input_html => {
                  :class => "picka#{options.type}",
                  :value => val.nil? ? nil : val
                }, :readonly => readonly)
      elsif options.type == 'datetime'
        content_tag(:div, :class => 'input string pickadatetime') do
          o2 = content_tag(:label, label)
          o2 += content_tag(:input, '', :label => label, :placeholder => 'Date',
                            :type => 'text', :class => 'pickadatetime-date',
                            :value => obj.send(attr).present? ?
                              obj.send(attr).strftime("%d %B, %Y") : '',
                            :readonly => readonly)
          o2 += content_tag(:input, '', :label => label, :placeholder => 'Time',
                            :type => 'text', :class => 'pickadatetime-time',
                            :value => obj.send(attr).present? ?
                              obj.send(attr).strftime("%l:%M %p") : '',
                            :readonly => readonly)
          o2 += f.input(attr.to_sym, :as => :hidden, :wrapper => false,
                        :label => false,
                        :input_html => { :class => 'pickadatetime' })
        end
      elsif options.type == 'markdown'
        content_tag(:div, :class => "input text optional #{attr}") do
          o2  = content_tag(:label, label, :for => attr)
          o2 += content_tag(:div, f.markdown(attr.to_sym), :class => 'markdown')
        end
      elsif options.type == 'wysiwyg'
        f.input(attr.to_sym, :as => :text, :label => label,
                :input_html => { :class => 'editor' })
      elsif options.type == 'file'
        o = f.input(attr.to_sym, :as => options.type, :label => label,
                :readonly => readonly)
        o += link_to(obj.send(attr).name, obj.send(attr).url, :class => 'file',
                     :target => :blank) unless obj.send(attr).blank?
        o
      else
        f.input(attr.to_sym, :as => options.type, :label => label,
                :readonly => readonly)
      end
    end

    def cambium_route(action, obj = nil)
      case action
      when :index
        begin
          main_app
            .polymorphic_path [:admin, obj.class.to_s.tableize.pluralize.to_sym]
        rescue
          cambium.polymorphic_path [:admin, obj.class.to_s.tableize.pluralize.to_sym]
        end
      when :edit
        begin
          main_app.polymorphic_path [:edit, :admin, obj]
        rescue
          cambium.polymorphic_path [:edit, :admin, obj]
        end
      else
        begin
          main_app.polymorphic_path [:admin, obj]
        rescue
          cambium.polymorphic_path [:admin, obj]
        end
      end
    end

    def is_index?
      action_name == 'index'
    end

    def is_edit?
      ['edit','update'].include?(action_name)
    end

    def has_new_form?
      admin_view.form.present? && admin_view.form.new.present?
    end

    def can_delete?
      admin_view.form.present? && admin_view.form.buttons.present? &&
        admin_view.form.buttons.delete.present?
    end

  end
end
