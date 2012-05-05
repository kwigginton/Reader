# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Reader::Application.initialize!

#puts 'Creating initial admin user...'
#User.create(name: 'hail', role: 'admin', password: 'ophelia', password_confirmation: 'ophelia')