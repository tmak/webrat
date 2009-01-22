module Webrat
  class MerbHandler
    attr_reader :default_test_framework # :nodoc:
    attr_reader :default_mode # :nodoc:
    attr_reader :supported_modes # :nodoc:

    def initialize # :nodoc:
      @default_test_framework = :rspec
      @default_mode = :merb
      @supported_modes= [:merb, :selenium]
    end
  end
end
