class SessionsController < ApplicationController
  skip_before_filter :authorize_reader, :authorize_admin
  
  def new
  end

  def create
      user = User.find_by_name(params[:name])
      if user and user.authenticate(params[:password])
        session[:user_id] = user.id
        
   #     case user.role
    #    when User.admin
    #      redirect_to admin_url
    #    when User.reader
    #      redirect_to reader_url
    #    end
        redirect_to eval("#{user.role}_url")
        
      else
        redirect_to login_url, alert: "Invalid user/password combination"
      end
    end

    def destroy
      session[:user_id] = nil
      redirect_to welcome_url, notice: "Logged out"
    end
end
