module Webrat
  class RailsHandler
    attr_reader :default_test_framework # :nodoc:
    attr_reader :default_mode # :nodoc:
    attr_reader :supported_modes # :nodoc:

    def initialize # :nodoc:
      @default_test_framework = :test_unit
      @default_mode = :rails
      @supported_modes= [:rails, :mechanize, :selenium]
    end

    def start_app_server #:nodoc:
      pid_file = prepare_pid_file("#{RAILS_ROOT}/tmp/pids", "mongrel_selenium.pid")
      system("mongrel_rails start -d --chdir=#{RAILS_ROOT} --port=#{Webrat.configuration.application_port} --environment=#{Webrat.configuration.application_environment} --pid #{pid_file} &")
      TCPSocket.wait_for_service :host => Webrat.configuration.application_address, :port => Webrat.configuration.application_port.to_i
    end

    def stop_app_server #:nodoc:
      pid_file = File.expand_path(RAILS_ROOT + "/tmp/pids/mongrel_selenium.pid")
      system "mongrel_rails stop -c #{RAILS_ROOT} --pid #{pid_file}"
    end

  private
    def prepare_pid_file(file_path, pid_file_name)
      FileUtils.mkdir_p File.expand_path(file_path)
      File.expand_path("#{file_path}/#{pid_file_name}")
    end
  end
end
