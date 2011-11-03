module ApplicationHelper
  
  
  def logo
    image_tag("images/logo.gif", :alt => "", :style => "vertical-align:middle")
  end
  
  def title
    base_title = "Karma"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
end
