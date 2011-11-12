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
  
  # These make sure the Devise links work outside of the Devise controller
      
    def resource_name
      :user
    end

    def resource
      @resource ||= User.new
    end

    def devise_mapping
      @devise_mapping ||= Devise.mappings[:user]
    end

  
end
