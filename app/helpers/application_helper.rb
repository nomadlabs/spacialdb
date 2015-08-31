module ApplicationHelper
  def alert_class_for(flash_type)
    {
      :success => 'alert-success',
      :error => 'alert-danger',
      :alert => 'alert-warning',
      :notice => 'alert-info'
    }[flash_type.to_sym] || flash_type.to_s
  end

  def nav_link_to(link_text, link_path)
    class_name = current_page?(link_path) ? 'active' : nil
    content_tag(:li, :class => class_name) do
      link_to link_text, link_path
    end
  end

end
