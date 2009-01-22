require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require "action_controller"
require "action_controller/integration"
require "webrat/modes/selenium"


describe Webrat, "Selenium" do

  describe "start_selenium_server" do
    it "should not start the local selenium server if the selenium_server_address is set" do
      Webrat.configuration.selenium_server_address = 'foo address'
      ::Selenium::RemoteControl::RemoteControl.should_not_receive(:new)
      TCPSocket.should_receive(:wait_for_service).with(:host => Webrat.configuration.selenium_server_address, :port => Webrat.configuration.selenium_server_port)
      Webrat.start_selenium_server
    end

    it "should start the local selenium server if the selenium_server_address is set" do
      remote_control = mock "selenium remote control"
      ::Selenium::RemoteControl::RemoteControl.should_receive(:new).with("0.0.0.0", Webrat.configuration.selenium_server_port, 5).and_return remote_control
      remote_control.should_receive(:jar_file=).with(/selenium-server\.jar/)
      remote_control.should_receive(:start).with(:background => true)
      TCPSocket.should_receive(:wait_for_service).with(:host => "0.0.0.0", :port => Webrat.configuration.selenium_server_port)
      Webrat.start_selenium_server
    end
  end

  describe "stop_selenium_server" do

    it "should not attempt to stop the server if the selenium_server_address is set" do
      Webrat.configuration.selenium_server_address = 'foo address'
      ::Selenium::RemoteControl::RemoteControl.should_not_receive(:new)
      Webrat.stop_selenium_server
    end

    it "should stop the local server is the selenium_server_address is nil" do
      remote_control = mock "selenium remote control"
      ::Selenium::RemoteControl::RemoteControl.should_receive(:new).with("0.0.0.0", Webrat.configuration.selenium_server_port, 5).and_return remote_control
      remote_control.should_receive(:stop)
      Webrat.stop_selenium_server
    end
  end
end