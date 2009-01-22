require File.expand_path(File.dirname(__FILE__) + "/../webrat")

Webrat.configure do |config|
  config.application_framework = :sinatra
end
