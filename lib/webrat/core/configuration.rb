require "webrat/core_extensions/deprecate"

module Webrat

  # Configures Webrat. If this is not done, Webrat will be created
  # with all of the default settings.
  def self.configure(configuration = Webrat.configuration)
    yield configuration if block_given?
    @@configuration = configuration
  end

  def self.configuration # :nodoc:
    @@configuration ||= Webrat::Configuration.new
  end

  # Webrat can be configured using the Webrat.configure method. For example:
  #
  #   Webrat.configure do |config|
  #     config.parse_with_nokogiri = false
  #   end
  class Configuration

    # Should XHTML be parsed with Nokogiri? Defaults to true, except on JRuby. When false, Hpricot and REXML are used
    attr_writer :parse_with_nokogiri

    # Which framework does the application to be tested use.
    attr_reader :application_framework
    
    # Which test framework does the application to be tested use.
    attr_writer :test_framework

    # Save and open pages with error status codes (500-599) in a browser? Defualts to true.
    attr_writer :open_error_files

    # Which rails environment should the selenium tests be run in? Defaults to selenium.
    attr_accessor :application_environment
    webrat_deprecate :selenium_environment, :application_environment
    webrat_deprecate :selenium_environment=, :application_environment=

    # Which port is the application running on for selenium testing? Defaults to 3001.
    attr_accessor :application_port
    webrat_deprecate :selenium_port, :application_port
    webrat_deprecate :selenium_port=, :application_port=

    # Which server the application is running on for selenium testing? Defaults to localhost
    attr_accessor :application_address

    # Which server Selenium server is running on. Defaults to nil(server starts in webrat process and runs locally)
    attr_accessor :selenium_server_address

    # Which server Selenium port is running on. Defaults to 4444
    attr_accessor :selenium_server_port

    # Set the key that Selenium uses to determine the browser running. Default *firefox
    attr_accessor :selenium_browser_key

    def initialize # :nodoc:
      self.open_error_files = true
      self.parse_with_nokogiri = !Webrat.on_java?
      self.application_environment = :selenium
      self.application_port = 3001
      self.application_address = 'localhost'
      self.selenium_server_port = 4444
      self.selenium_browser_key = '*firefox'
    end

    def parse_with_nokogiri? #:nodoc:
      @parse_with_nokogiri ? true : false
    end

    def open_error_files? #:nodoc:
      @open_error_files ? true : false
    end

    # Allows setting of the framework that is used by the application to be tested, valid application framework are:
    # :rails, :merb, :sinatra
    def application_framework=(application_framework)
      @application_framework = application_framework.to_sym
      require("webrat/application_frameworks/#{application_framework}")
    end

    def test_framework
      self.test_framework = Webrat.application_framework_handler.default_test_framework if @test_framework.nil?
      @test_framework
    end

    # Webrat's mode, set automatically to the default mode of the framework that is used by the application to be tested
    def mode
      self.mode = Webrat.application_framework_handler.default_mode if @mode.nil?
      @mode
    end
    
    # Allows setting of webrat's mode, valid modes are:
    # :rails, :selenium, :rack, :sinatra, :mechanize, :merb
    def mode=(mode)
      mode = mode.to_sym

      if [:rails, :merb, :sinatra].include?(mode) && @application_framework.nil?
        warn "Please use the option application_framework to set the framework which the application to be tested use."
        self.application_framework = mode
        return
      end

      unless Webrat.application_framework_handler.supported_modes.include?(mode)
        raise WebratError.new("The mode #{mode.inspect} is not supported by #{@application_framework.inspect}")
      end

      @mode = mode
      require("webrat/modes/#{mode}")
    end

  end

end