module ApplicationHelper
  def name(resource)
    "#{resource.first_name} #{resource.last_name}"
  end
end
