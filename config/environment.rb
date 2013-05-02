# Load the rails application
require File.expand_path('../application', __FILE__)

FACEBOOK_CONFIG = YAML.load_file("#{::Rails.root}/config/facebook.yml")[::Rails.env]

FACEBOOK_APP_ID = FACEBOOK_CONFIG['app_id']

# Initialize the rails application
Maple::Application.initialize!
