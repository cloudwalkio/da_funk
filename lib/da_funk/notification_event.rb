module DaFunk
  class NotificationEvent
    attr_reader :id, :event, :parameters, :callback

    def perform
      Notification.execute(self)
    end

    #"3|SHOW_MESSAGE|TEST1|12-20-2017 18:23"
    def initialize(event)
      values = event.to_s.split("|")
      @id    = values.shift # id
      @callback, *@parameters = values
    end

    private

    def reply
      if id
        {"type" => "pnconf","event" => "#{id}"}.to_json
      end
    end
  end
end

