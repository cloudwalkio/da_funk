module DaFunk
  class Engine
    def self.check
      DaFunk::EventListener.check
      DaFunk::Helper::StatusBar.check
    end

    def self.app_loop(&block)
      @stop = false
      loop do
        self.check
        break if @stop
        block.call
      end
      ThreadScheduler.stop
    end

    def self.stop!
      @stop = true
    end
  end
end

