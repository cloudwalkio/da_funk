module DaFunk
  class PaymentChannel
    DEFAULT_HEARBEAT = "180"

    class << self
      attr_accessor :current, :app
    end

    attr_accessor :handshake_response, :handshake_request, :client, :host, :port

    # Backward compatibility
    def self.client
      self.current
    end

    # Backward compatibility
    def self.client=(obj)
      self.current = obj
    end

    def self.current
      @current
    end

    def self.current=(obj)
      @current = obj
    end

    def self.ready?
      Device::Network.connected? && self.configured?
    end

    def self.configured?
      DaFunk::ParamsDat.file["access_token"] &&
        DaFunk::ParamsDat.file["payment_channel_enabled"] == "1" &&
        Device::Setting.logical_number
    end

    def self.app=(application)
      if @app != application
        @app = application
        # if Context::CommunicationChannel send application name thought threads
        if self.current == Context::CommunicationChannel
          self.current.app = application
        else
          Device::System.klass = application
        end
      end
      @app
    end

    def self.handshake_message
      {
        "token"     => DaFunk::ParamsDat.file["access_token"],
        "id"        => Device::Setting.logical_number.to_s,
        "heartbeat" => Device::Setting.heartbeat || DEFAULT_HEARBEAT
      }.to_json
    end

    def self.handshake_success_message
      {"token" => DaFunk::ParamsDat.file["access_token"]}.to_json
    end

    def self.connect(display_message = true)
      if self.dead? && self.ready?
        self.print_info(I18n.t(:attach_attaching), display_message)
        create
        self.print_info(I18n.t(:attach_authenticate), display_message)
        self.current.handshake
      else
        client_clear!
      end
      self.current
    end

    def self.payment_channel_limit?
      DaFunk::ParamsDat.exists? && DaFunk::ParamsDat.file["payment_channel_check_limit"] == "1"
    end

    def self.payment_channel_limit
      if DaFunk::ParamsDat.exists?
        DaFunk::ParamsDat.file["payment_channel_limit"].to_i
      else
        0
      end
    end

    def self.transaction_http?
      DaFunk::ParamsDat.exists? && DaFunk::ParamsDat.file["transaction_http_enabled"] != "0"
    end

    def self.channel_limit_exceed?
      return true if transaction_http?
      if payment_channel_limit?
        payment_channel_limit <= Device::Setting.payment_channel_attempts.to_i
      else
        false
      end
    end

    def self.check(display_message = true)
      if self.dead?
        unless self.channel_limit_exceed?
          PaymentChannel.connect(display_message)
          if self.current
            self.print_info(I18n.t(:attach_waiting), display_message)
            if message = self.current.check || self.current.handshake?
              self.print_info(I18n.t(:attach_connected), display_message)
              message
            end
          end
        end
      else
        self.current&.check
      end
    end

    def self.dead?
      ! self.alive?
    end

    def self.alive?
      Device::Network.connected? && self.current&.connected?
    end

    def self.close!
      self.current&.close
    ensure
      client_clear!
    end

    def self.print_info(message, display = true)
      print_last(message) if display
    end

    def self.payment_channel_increment_attempts
      number = Device::Setting.payment_channel_attempts.to_i
      date   = Device::Setting.payment_channel_date
      if date.to_s.empty?
        Device::Setting.payment_channel_set_attempts(Time.now)
      else
        year, mon, day = date.split("-")
        if day.to_i == Time.now.day
          Device::Setting.payment_channel_set_attempts(nil, number + 1)
        else
          Device::Setting.payment_channel_set_attempts(Time.now)
        end
      end
    end

    def self.create
      if self.current != Context::CommunicationChannel
        payment_channel_increment_attempts
        self.current = PaymentChannel.new
      else
        self.current.connect
      end
    end

    def self.client_clear!
      self.current = nil unless self.current == Context::CommunicationChannel
    end

    def initialize(client = nil)
      @host   = Device::Setting.host
      @port   = (Device::Setting.apn == "gprsnac.com.br") ? 32304 : 443
      if PaymentChannel.transaction_http?
        @client = client || CwHttpSocket.new
      else
        @client = client || CwWebSocket::Client.new(@host, @port)
      end
    rescue SocketError, PolarSSL::SSL::Error => e
      self.error(e)
    end

    def code
      if PaymentChannel.transaction_http? && @client
        @client.code
      end
    end

    def write(value)
      if Object.const_defined?(:Cloudwalk) && value.is_a?(Cloudwalk::HttpEvent)
        @client.write(value.message)
      else
        @client.write(value)
      end
    end

    def read
      begin
        @client.read
      rescue SocketError, PolarSSL::SSL::Error => e
        self.error(e)
      end
    end

    def close
      @client&.close
      @client = nil
      PaymentChannel.current = nil
    end

    def connected?
      self.client&.connected?
    end

    def handshake?
      if self.client.respond_to?(:handshake?)
        self.client.handshake?
      else
        if self.connected? && @handshake_request && ! @handshake_response
          timeout = Time.now + Device::Setting.tcp_recv_timeout.to_i
          loop do
            break if @handshake_response = self.client.read
            break if Time.now > timeout || getc(200) == Device::IO::CANCEL
          end
        end
        !! @handshake_response
      end
    end

    def check
      if Device::Network.connected? && self.connected? && self.handshake?
        self.read
      end
    end

    private
    def error(exception)
      if Context.development?
        ContextLog.exception(exception, exception.backtrace, "PaymentChannel error")
      end
      self.close
    end

    def handshake
      if self.connected?
        if self.handshake?
          true
        else
          @handshake_request = PaymentChannel.handshake_message
          @client.write(handshake_request)
        end
      end
    end
  end
end

