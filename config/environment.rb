# Load the Rails application.
require File.expand_path('../application', __FILE__)

keys = File.join(Rails.root, 'config', 'keys.rb')
load(keys) if File.exists?(keys)

# Initialize the Rails application.
Rails.application.initialize!
