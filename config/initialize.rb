require 'i18n'

# Set the locales files path
I18n.load_path << Dir[File.expand_path("./config/locales") + "/*.yml"]