# Require external dependencies
require 'i18n'
require 'wisper'
require 'pry'

# Set the locales files path
I18n.load_path << Dir[File.expand_path("./config/locales") + "/*.yml"]

# Require application components
Dir['./lib/*.rb'].each {|file| require file }