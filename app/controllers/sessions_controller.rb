class SessionsController < ApplicationController
  skip_before_filter :authorize_reader, :authorize_admin
  
  def new
    @user = User.new
  end

  def create
      user = User.find_by_email(params[:email].downcase)
      if user and user.authenticate(params[:password])
        session[:user_id] = user.id
        
        if session[:return_to]
          redirect_to session[:return_to]
          session[:return_to] = nil
          return
        end
        redirect_to welcome_url #eval("#{user.role}_url")
        
      else
        redirect_to login_url, :alert => "Invalid Email or Password"
      end
    end

    def destroy
      session[:user_id] = nil
      redirect_to welcome_url, :notice => "Logged out"
    end
end
