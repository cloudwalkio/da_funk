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
    rescue ArgumentError
      File.delete("main/schedule.dat")
      Device::System.reboot
    end

    def seconds_from_file
      unless option[:slot] && option[:hours]
        raise "slot or hours missing on EventHandler creation"
      end

      db     = FileDb.new("main/schedule.dat")
      string = db[option[:slot]]
      config = parse_slot(string)

      unless config
        # configure from scrath
        config = {"timestamp" => nil, "interval" => stringify_hours(option)}
      end

      unless config["timestamp"]
        config["timestamp"] = hours2seconds(option["interval"])
      else
        if config["interval"]["hours"].to_s != option[:hours].to_s
          config["timestamp"] = hours2seconds(option[:hours])
          config["interval"]["hours"] = option[:hours].to_s
        else
          if self.timer && self.timer.to_i <= Time.now.to_i
            config["timestamp"] = hours2seconds(option[:hours])
            config["interval"]["hours"] = option[:hours].to_s
          end
        end
      end

      db[option[:slot]] = config.to_json

      config["timestamp"].to_i
    end

    def execute?
      schedule_timer unless self.timer
      if self.timer
        self.timer < Time.now
      else
        ! self.timer
      end
    end

    private
    def stringify_hours(options)
      {"hours" => options[:hours]}
    end

    def hours2seconds(interval)
      hours = 60 * 60 * interval.to_i
      hours = 99_999 if hours == 0
      (Time.now.to_i + hours)
    end

    def parse_slot(string)
      unless string.to_s.empty?
        JSON.parse(string)
      end
    rescue # old format slot=<fixnum>
      nil
    end
  end
end

