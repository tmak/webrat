require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')
require "webrat/application_frameworks/rails"

RAILS_ROOT = "/"


describe Webrat::RailsHandler do
  it "should start the app server with correct config options" do
    pid_file = "file"
    File.should_receive(:expand_path).with(RAILS_ROOT + "/tmp/pids/mongrel_selenium.pid").and_return pid_file
    Webrat.should_receive(:system).with("mongrel_rails start -d --chdir=#{RAILS_ROOT} --port=#{Webrat.configuration.application_port} --environment=#{Webrat.configuration.application_environment} --pid #{pid_file} &")
    TCPSocket.should_receive(:wait_for_service).with(:host => Webrat.configuration.application_address, :port => Webrat.configuration.application_port.to_i)
    Webrat::RailsHandler.start_app_server
  end
end
