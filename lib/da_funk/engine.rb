module DaFunk
  class Engine
    def self.check
      if Device::Setting.boot == '1'
        DaFunk::EventListener.check(:file_exists) #to check if system update is in progress
        Device::Setting.boot = '0'
      else
        DaFunk::EventListener.check
        ThreadScheduler.keep_alive
      end
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

