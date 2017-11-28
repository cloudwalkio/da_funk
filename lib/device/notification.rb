
class Device
  class Notification
    DEFAULT_TIMEOUT           = 20
    DEFAULT_INTERVAL          = 10
    DEFAULT_STREAM_TIMEOUT    = 0
    DEFAULT_CREATION_INTERVAL = 180

    class << self
      attr_accessor :callbacks, :current, :last_creation, :creation_interval, :last_event
    end

    self.callbacks = Hash.new
    self.creation_interval = DEFAULT_CREATION_INTERVAL

    attr_reader :fiber, :timeout, :interval, :last_check, :stream_timeout

    def self.check
      self.current.check if self.current
    end

    def self.execute(event)
      calls = self.callbacks[event.callback]
      return unless calls
      [:before, :on, :after].each do |moment|
        calls.each{|callback| callback.call(event, moment)}
      end
    end

    def self.schedule(callback)
      self.callbacks[callback.description] ||= []
      self.callbacks[callback.description] << callback
    end

    def self.config
      self.creation_interval      = Device::Setting.notification_socket_timeout.empty? ? DEFAULT_CREATION_INTERVAL : Device::Setting.notification_socket_timeout.to_i
      notification_timeout        = Device::Setting.notification_timeout.empty? ? DEFAULT_TIMEOUT : Device::Setting.notification_timeout.to_i
      notification_interval       = Device::Setting.notification_interval.empty? ? DEFAULT_INTERVAL : Device::Setting.notification_interval.to_i
      notification_stream_timeout = Device::Setting.notification_stream_timeout.empty? ? DEFAULT_STREAM_TIMEOUT : Device::Setting.notification_stream_timeout.to_i
      [notification_timeout, notification_interval, notification_stream_timeout]
    end

    def self.start
      if create_fiber? && Device::Network.connected?
        unless Device::Notification.current && Device::Notification.current.closed?
          self.new(*self.config)
        end
      end
    end

    def self.create_fiber?(force = false)
      (! Device::Setting.company_name.empty?) &&
        (! Device::Setting.logical_number.empty?) &&
        (force || self.valid_creation_interval?) &&
        Device::ParamsDat.file["notification_enabled"] == "1"
    end

    def self.valid_creation_interval?
      if @last_creation
        (@last_creation + self.creation_interval) < Time.now
      else
        true
      end
    end

    def initialize(timeout = DEFAULT_TIMEOUT, interval = DEFAULT_INTERVAL, stream_timeout = DEFAULT_STREAM_TIMEOUT)
      @timeout        = timeout
      @stream_timeout = stream_timeout
      @interval       = interval
      Device::Notification.current = self
      @fiber = create_fiber
    end

    # Check if there is any notification
    def check
      # TODO check if should execute this(because of connection exception)
      if valid_check_interval? && Device::Network.connected?
        if @fiber.alive?
          if (notification = @fiber.resume)
            Notification.execute(NotificationEvent.new(notification))
          end
        else
          if Device::Notification.create_fiber?(true)
            self.close
            @fiber = create_fiber
          end
        end
        @last_check = Time.now
      end
    end

    # Close socket and finish Fiber execution
    def close
      if closed?
        true
      else
        ! @fiber.resume "close"
      end
    end

    def closed?
      ! @fiber.alive?
    end

    def valid_check_interval?
      if @last_check
        (@last_check + self.interval) < Time.now
      else
        true
      end
    end

    def valid_event_interval?
      if @last_event
        (@last_event + Notification.creation_interval) < Time.now
      else
        true
      end
    end

    private
    def reply(conn, ev)
      if ev.is_a?(Hash)
        if ev["Event"] == "user" && ev["Payload"] && ev["Payload"].include?("Id")
          index = ev["Payload"].index("\"Id")
          id = ev["Payload"][(index+7)..(index+38)]
          @last_event = Time.now
          conn.event(event_name, "{\"Id\"=>\"#{id}\"}", false)
        end
      elsif ev.nil?
        if self.valid_event_interval?
          @last_event = Time.now
          conn.event(event_name, "", false)
        end
      end
    end

    def check_errors(exception)
      case exception.message
      when "Invalid authentication token"
        Device::Setting.cw_pos_timezone = "" # Clear timezone if authentication error
      when "Socket closed"
      else
      end
      false
    end

    def create_fiber
      Fiber.new do
        begin
          Serfx.connect(socket_block: Device::Network.socket, timeout: timeout, stream_timeout: stream_timeout) do |conn|
            @last_event = Time.now
            conn.auth(CloudwalkTOTP.at)
            Device::Notification.last_creation = Time.now
            conn.stream(subscription) { |ev| reply(conn, ev) }
          end
          true
        rescue => exception
          check_errors(exception)
        end
      end
    end

    def subscription
      "user:#{event_name}"
    end

    def event_name
      "#{Device::Setting.company_name};#{Device::Setting.logical_number}"
    end
  end
end

