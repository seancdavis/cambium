module Admin::PagesHelper

  def link_to_delete_page(page)
    link_to 'Delete', admin_page_path(page), :method => :delete, 
      :data => { :confirm => SETTINGS['pages']['delete_warning'] }
  end

  def link_to_edit_page(page)
     link_to 'Edit', edit_admin_page_path(page)
  end

  def page_template_field(type, name)
    value = @page.template_data.nil? ? '' : @page.template_data[name]
    html_output = ''
    case type
    when 'string'
      html_output << <<-eos
        <div class="control-group string required page_title">
          <label class="string control-label" for="page_#{name}">
              #{name.titleize}
          </label>
          <div class="controls">
            <input class="string required"
                   id="page_#{name}"
                   name="page[template_data][#{name}]" 
                   type="text"
                   value="#{value}">
          </div>
        </div>
      eos
    when 'text'
      html_output << <<-eos
        <div class="control-group string required page_title">
          <label class="string control-label" for="page_#{name}">
              #{name.titleize}
          </label>
          <div class="controls">
            <textarea class="text required" id="page_#{name}"
              name="page[template_data][#{name}]">#{value}</textarea>
          </div>
        </div>
      eos
    end
    html_output
  end

end