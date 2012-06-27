class WelcomeController < ApplicationController
  skip_before_filter :authorize_reader, :authorize_admin
  layout nil
  
  def index
  end
end
