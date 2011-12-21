module SessionsHelper

    def redirect_back_or(default)
      redirect_to(request.referer || default)
      clear_return_to
    end

  private

    def clear_return_to
      session[:return_to] = nil
    end
      
end
