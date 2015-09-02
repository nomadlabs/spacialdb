module ApplicationHelper
  def alert_class_for(flash_type)
    {
      :success => 'alert-success',
      :error => 'alert-danger',
      :alert => 'alert-warning',
      :notice => 'alert-info'
    }[flash_type.to_sym] || flash_type.to_s
  end

  def sortable(column, title)
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link = link_to :sort => column, :direction => direction do
      content_tag(:span, "", :class => "glyphicon glyphicon-sort")
    end
    (title + " " + link).html_safe
  end
end
