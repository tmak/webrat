module Webrat
  class SinatraHandler
    attr_reader :default_mode # :nodoc:
    attr_reader :supported_modes # :nodoc:

    def initialize # :nodoc:
      @default_mode = :sinatra
      @supported_modes= [:sinatra, :selenium]
    end
  end
end
