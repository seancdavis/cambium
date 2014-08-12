module AdminHelper

  # --------------------------------- Inflectors

  def model_plural
    @model.to_s.tableize.humanize.titleize
  end

  def model_singular
    model_plural.singularize
  end

  def model_table
    @model.to_s.tableize
  end

  def model_table_singular
    model_table.singularize
  end

  # --------------------------------- Routes

  def set_routes
    @routes = {
      :index => send("admin_#{model_table}_path"),
      :new => send("new_admin_#{model_table_singular}_path")
    }
    unless params[:id].nil?
      @item = @model.find_by_id(params[:id])
      @item = @model.find_by_slug(params[:id]) if @item.nil?
      @routes.merge!(
        :show => send("admin_#{model_table_singular}_path", @item),
        :edit => send("edit_admin_#{model_table_singular}_path", @item)
      )
    end
  end

  # --------------------------------- Forms

  def form_page(options = {})
    render :partial => 'admin/shared/forms/form_page', :locals => options
  end

  def form_section(title, options = {}, &block)
    state = options[:open].nil? ? true : options[:open]
    render :partial => 'admin/shared/forms/form_section', :locals => {
      :title => title, :open => state, :content => capture(&block) }
  end

  def form_column(title, side = 'left', &block)
    side ||= 'left'
    render :partial => "admin/shared/forms/form_column_#{side}", :locals => {
      :title => title, :content => capture(&block) }
  end

  def wysiwyg(form, field = :body, idx = 1)
    render :partial => 'admin/shared/forms/editor', :locals => {
      :f => form, :field => field, :idx => idx }
  end

  def publishable_fields(form)
    render :partial => 'admin/shared/forms/publishable', :locals => { :f => form }
  end

  def wysihtml5_icon(cmd,icon = cmd,options = {})
    options[:cmd] = "data-wysihtml5-command-value='#{options[:cmd]}'" unless options[:cmd] == ''
    "<a data-wysihtml5-command='#{cmd}' #{options[:cmd]} id='#{options[:id]}' 
      class='#{options[:class]}'>
      <i class='icon-#{icon}'></i>
    </a>".html_safe
  end

  def wysihtml5_link(cmd,val=cmd,options={})
    options[:cmd] = "data-wysihtml5-command-value='#{options[:cmd]}'" unless options[:cmd] == ''
    "<a data-wysihtml5-command='#{cmd}' #{options[:cmd]} id='#{options[:id]}' class='#{options[:class]}'>
      #{val}
    </a>".html_safe
  end

  # --------------------------------- Nav

  def admin_nav_items
    items = [
      {
        :label => 'Users',
        :icon => 'user',
        :path => admin_users_path,
        :controllers => ['users']
      },
      {
        :label => 'Visit Site',
        :icon => 'home',
        :path => root_path,
        :target => :blank
      },
      {
        :label => 'Logout',
        :icon => 'exit',
        :path => destroy_user_session_path
      }
    ]
    if File.exist?("#{Rails.root}/app/controllers/admin/pages_controller.rb")
      items.unshift(
        {
          :label => 'Pages',
          :icon => 'file3',
          :path => admin_pages_path,
          :controllers => ['pages']
        }
      )
    end
    items
  end

  def nav_active?(controllers)
    unless controllers.nil?
      controllers.each do |controller|
        return true if controller_name == controller
      end
    end
    false
  end

  # --------------------------------- Misc

  def icon_to(icon, path, options = {})
    link_to path, :class => options[:class] do
      "<i class='icon-#{icon}'></i>".html_safe
    end
  end

end
