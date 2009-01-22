module Webrat
  class MerbHandler
    attr_reader :default_mode # :nodoc:
    attr_reader :supported_modes # :nodoc:

    def initialize # :nodoc:
      @default_mode = :merb
      @supported_modes= [:merb, :selenium]
    end
  end
end
