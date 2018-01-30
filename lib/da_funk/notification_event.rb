module DaFunk
  class NotificationEvent
    attr_reader :id, :event, :acronym, :logical_number, :parameters, :callback

    def perform
      Notification.execute(self)
    end

    def initialize(id, event, acronym, logical_number)
      @id             = id
      @acronym        = acronym
      @logical_number = logical_number
      parse(event)
    end

    private

    #{"id":3,"event":"3|SHOW_MESSAGE|TEST1|12-20-2017 18:23","acronym":"pc1","logical_number":"5A179615"}
    #"3|SHOW_MESSAGE|TEST1|12-20-2017 18:23"
    def parse(event)
      values = event.to_s.split("|")
      values.shift # id
      @callback, *@parameters = values
    end

    def reply
      if id
        {"type" => "pnconf","event" => "#{id}"}.to_json
      end
    end
  end
end

