
module DaFunk
  class Notification
    class << self
      attr_accessor :callbacks
    end

    self.callbacks = Hash.new

    def self.check(msg)
      if msg.is_a?(String) && msg.include?("\"message\"") && msg.include?("|")
        [:notification, NotificationEvent.new(JSON.parse(msg)["message"])]
      else
        msg
      end
    rescue ArgumentError => e
      if e.message == "invalid json"
        msg
      else
        raise
      end
    end

    def self.execute(event)
      calls = self.callbacks[event.callback]
      return unless calls
      [:before, :on, :after].each do |moment|
        calls.each do |callback|
          callback.call(event, moment)
        end
      end
    end

    def self.schedule(callback)
      self.callbacks[callback.description] ||= []
      self.callbacks[callback.description] << callback
    end
  end
end

