module DaFunk
  class ScreenFlow
    class << self
      attr_accessor :screen_methods, :setup
    end
    attr_reader :screens

    def self.screen(method, &block)
      self.screen_methods ||= []
      self.screen_methods << method
      define_method method do
        @screens << CallbackFlow.new(self, @screens.last, &block)
      end
    end

    def initialize
      @screens = []
      self.class.screen_methods.each{|method| send(method) }
    end

    def self.setup(&block)
      define_method(:setup, &block)
    end

    def setup
    end

    def start
      first = self.screens.first
      first.dispatch(true) if first
    end

    def confirm(text)
      puts text.chomp
      getc(0)
    end
  end
end

