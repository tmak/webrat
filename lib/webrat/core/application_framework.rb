module Webrat
  def self.application_framework_handler_class
    case Webrat.configuration.application_framework
    when :rails
      RailsHandler
    when :merb
      MerbHandler
    when :sinatra
      SinatraHandler
    else
      raise WebratError.new(<<-STR)
Unknown application framework: #{Webrat.configuration.application_framework.inspect}

Please ensure you have a Webrat configuration block that specifies the application framework
in your test_helper.rb, spec_helper.rb, or env.rb (for Cucumber).
For example:

  Webrat.configure do |config|
    config.application_framework = :rails
  end
      STR
    end
  end

  def self.application_framework_handler
    @_application_framework_handler ||= ::Webrat.application_framework_handler_class.new
  end
end
