module DaFunk
  class Engine
    def self.check
      DaFunk::EventListener.check
      ThreadScheduler.keep_alive
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

    def self.stop!(reload = false)
      Device::Runtime.reload if reload
      @stop = true
    end
  end
end

