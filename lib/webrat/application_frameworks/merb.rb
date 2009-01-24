module Webrat
  class MerbHandler
    attr_reader :default_test_framework # :nodoc:
    attr_reader :default_mode # :nodoc:
    attr_reader :supported_modes # :nodoc:

    def initialize # :nodoc:
      @default_test_framework = :rspec
      @default_mode = :merb
      @supported_modes= [:merb, :mechanize, :selenium]
    end

    def start_app_server #:nodoc:
      pid_file = File.expand_path(Merb.root + "/log/selenium.pid")
      system("merb -d --merb-root=#{Merb.root} --port=#{Webrat.configuration.application_port} --environment=#{Webrat.configuration.application_environment} --pid #{pid_file} &")
      TCPSocket.wait_for_service(:host => Webrat.configuration.application_address, :port => Webrat.configuration.application_port.to_i)
    end

    def stop_app_server #:nodoc:
      pid_file = File.expand_path(Merb.root + "/log/selenium.pid")
      system("merb --merb-root=#{Merb.root} -P #{pid_file} -K all")
    end
  end
end
