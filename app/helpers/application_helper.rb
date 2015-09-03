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

  def get_status(status)
    if status == "paid"
      content_tag(:span, "paid", :class => "label label-success")
    else
      content_tag(:span, "unpaid", :class => "label label-danger")
    end
  end

  def get_link_to(instance, status)
    if status == "paid"
      link_to 'Show', instance
    else
      link_to "Show and Pay", instance
    end
  end
end
