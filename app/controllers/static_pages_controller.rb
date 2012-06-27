class StaticPagesController < ApplicationController
  skip_before_filter :authorize_admin, :authorize_reader
  def about
  end

  def faq
  end
end
