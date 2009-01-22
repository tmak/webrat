require "rubygems"
require "test/unit"
require "redgreen"
require "sinatra"
require File.dirname(__FILE__) + "/../app"

require File.dirname(__FILE__) + "/../../../../lib/webrat/sinatra"

class Test::Unit::TestCase
  include Webrat::Methods
  
  Webrat::Methods.delegate_to_session :response_code, :response_body
end
