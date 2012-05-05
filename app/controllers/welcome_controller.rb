class WelcomeController < ApplicationController
  skip_before_filter :authorize_reader, :authorize_admin
  
  def index
  end
end
