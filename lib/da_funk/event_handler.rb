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
        if option.include?(:hours) && option.include?(:slot)
          self.timer = Time.at(seconds_from_file)
        elsif option.include?(:minutes)
          self.timer = Time.now + (option[:minutes].to_i * 60)
        elsif option.include?(:seconds)
          self.timer = Time.now + option[:seconds]
        end
      end
    end

    def seconds_from_file
      unless option[:slot] && option[:hours]
        raise "slot or hours missing on EventHandler creation"
      end

      db    = FileDb.new("main/schedule.dat")
      value = db[option[:slot]]

      if value.to_s.empty? || value.to_i <= Time.now.to_i
        hours = 60 * 60 * option[:hours].to_i
        hours = 99_999 if hours == 0
        value = (Time.now.to_i + hours)
        db[option[:slot]] = value
      end
      value.to_i
    end

    def execute?
      schedule_timer unless self.timer
      if self.timer
        self.timer < Time.now
      else
        ! self.timer
      end
    end
  end
end

