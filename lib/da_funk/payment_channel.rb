module DaFunk
  class PaymentChannel
    DEFAULT_HEARBEAT = "180"

    class << self
      attr_accessor :client
    end

    attr_accessor :handshake_response, :client, :host, :port

    def self.ready?
      Device::Network.connected? && self.configured?
    end

    def self.configured?
      DaFunk::ParamsDat.file["access_token"] &&
        DaFunk::ParamsDat.file["payment_channel_enabled"] == "1" &&
        Device::Setting.logical_number
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
        @client = PaymentChannel.new
        self.print_info(I18n.t(:attach_authenticate), display_message)
        @client.handshake
      else
        @client = nil
      end
      @client
    end

    def self.error
      if self.configured?
        if ConnectionManagement.fallback?
          :fallback_communication
        elsif ConnectionManagement.conn_automatic_management?
          :attach_registration_fail
        end
      end
    end

    def self.check(display_message = true)
      if self.dead?
        PaymentChannel.connect(display_message)
        if @client
          self.print_info(I18n.t(:attach_waiting), display_message)
          if message = @client.check || @client.handshake?
            self.print_info(I18n.t(:attach_connected), display_message)
            message
          else
            self.error
          end
        else
          self.error
        end
      else
        if @client
          @client.check
        end
      end
    end

    def self.dead?
      ! self.alive?
    end

    def self.alive?
      a = Device::Network.connected?
      a = Device::Network.connected?
      b = @client if @client
      c = @client.connected? if @client
      ContextLog.info "a[#{a}] b[#{b}] c[#{c}]"
      a && b && c
    end

    def self.close!
      @client && @client.close && @client = nil
    end

    def self.print_info(message, display = true)
      print_last(message) if display
    end

    def initialize(client = nil)
      @host   = Device::Setting.host
      @port   = (Device::Setting.apn == "gprsnac.com.br") ? 32304 : 443
      @client = client || CwWebSocket::Client.new(@host, @port)
    rescue SocketError, PolarSSL::SSL::Error => e
      self.error(e)
    end

    def write(value)
      @client.write(value)
    end

    def read
      begin
        @client.read
      rescue SocketError, PolarSSL::SSL::Error => e
        self.error(e)
      end
    end

    def close
      @client.close if @client
      @client = nil
      PaymentChannel.client = nil
    end

    def connected?
      self.client && self.client.connected?
    end

    def handshake?
      if self.connected? && ! @handshake_response
        timeout = Time.now + Device::Setting.tcp_recv_timeout.to_i
        loop do
          break if @handshake_response = self.client.read
          break if Time.now > timeout || getc(200) == Device::IO::CANCEL
        end
      end
      !! @handshake_response
    end

    def check
      if Device::Network.connected? && self.connected? && self.handshake?
        message = self.read
      end
      if message.nil? && ConnectionManagement.primary_try?
        return :primary_communication
      end
      message
    end

    private
    def error(exception)
      if Context.development?
        ContextLog.exception(exception, exception.backtrace, "PaymentChannel error")
      end
      PaymentChannel.client = nil
      @client = nil
    end

    def handshake
      if self.connected?
        @client.write(PaymentChannel.handshake_message)
      end
    end
  end
end

