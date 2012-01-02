module ApplicationHelper
  
  
  def logo
    image_tag("images/logo.gif", :alt => "", :style => "vertical-align:middle")
  end
  
  def title
    base_title = "Karma"
    @title.nil? ? base_title : "#{base_title} | #{@title}"
  end
  
  def error_messages!(context="")
   return "" if resource.errors.empty?

   messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
  
   if I18n.locale == :en
     sentence = "Oh no! There "
     if resource.errors.count == 1
   			sentence += "was one error"
   	 else
   	    sentence += "were " + resource.errors.count.en.numwords + " errors"
     end
   	 sentence += " with your #{context} information."
  
   else 
     sentence = I18n.t("errors.messages.not_saved",
                        :count => resource.errors.count,
                        :resource => resource.class.model_name.human.downcase)
   end
  
    html = <<-HTML
      <div id="error_explanation">
        <h2>#{sentence}</h2>
        <ul>#{messages}</ul>
      </div>
    HTML

    html.html_safe
  end

  def trunc_title(string, num)
    words = string.split(/\W+/)
    if words.count >= num
      return words[0..num-1].join(' ') + "..."
    else
      return words[0..words.count - 1].join(' ')
    end     
  end
      
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
