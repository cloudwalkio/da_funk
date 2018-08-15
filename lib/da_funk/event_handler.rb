module DaFunk
  class EventHandler
    attr_reader :option, :type
    attr_accessor :timer

    def initialize(type, option, &block)
      @type          = type
      @option        = option
      @perform_block = block
      register
    end

    def register
      schedule_timer
      EventListener.add_handler(self)
    end

    def perform(*parameter)
      if execute?
        schedule_timer
        @perform_block.call(*parameter)
      end
    end

    def schedule_timer
      if option.is_a?(Hash)
        if option.include?(:minutes)
          timer = Time.now + (option[:minutes].to_i * 60)
        elsif option.include?(:seconds)
          timer = Time.now + option[:seconds]
        end
      end
    end

    def execute?
      if timer
        timer < Time.now
      else
        true
      end
    end
  end
end

