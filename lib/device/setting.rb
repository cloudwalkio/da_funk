
class Device
  class Setting
    FILE_PATH       = "./main/config.dat"
    HOST_PRODUCTION      = "switch.cloudwalk.io"
    HOST_STAGING         = "switch-staging.cloudwalk.io"
    HTTP_HOST_PRODUCTION = "pos.cloudwalk.io"
    HTTP_HOST_STAGING    = "pos-staging.cloudwalk.io"
    HTTP_PORT            = "443"
    PORT_TCP             = "31415"
    PORT_TCP_SSL         = "31416"

    DEFAULT     = {
      "host"                        => HOST_PRODUCTION,
      "host_port"                   => PORT_TCP_SSL,
      "ssl"                         => "1", #COMM
      "media_primary"               => "", #COMM
      "user"                        => "", #GPRS
      "apn_password"                => "", #GPRS
      "apn"                         => "", #GPRS
      "sim_pin"                     => "", #GPRS
      "sim_slot"                    => "0", #GPRS
      "sim_dual"                    => "0", #GPRS
      "wifi_password"               => "", #WIFI
      "authentication"              => "", #WIFI
      "essid"                       => "", #WIFI
      "bssid"                       => "", #WIFI
      "cipher"                      => "", #WIFI
      "mode"                        => "", #WIFI
      "channel"                     => "", #WIFI
      "media"                       => "", #COMM
      "ip"                          => "", #COMM
      "gateway"                     => "", #COMM
      "dns1"                        => "", #COMM
      "dns2"                        => "", #COMM
      "subnet"                      => "", #COMM
      "phone"                       => "", #PPOE
      "modem_speed"                 => "", #PPOE
      "logical_number"              => "", #SYS
      "network_configured"          => "", #SYS
      "touchscreen"                 => "", #SYS
      "environment"                 => "", #SYS
      "attach_gprs_timeout"         => "", #COMM
      "attach_tries"                => "", #COMM
      "notification_socket_timeout" => "", #SYS Period to create fiber
      "notification_timeout"        => "", #SYS Time to wait message to read
      "notification_interval"       => "", #SYS Check interval
      "notification_stream_timeout" => "", #SYS Time to wait stream message to read
      "cw_switch_version"           => "", #SYS
      "cw_pos_timezone"             => "", #SYS
      "tcp_recv_timeout"            => "14", #COMM
      "iso8583_recv_tries"          => "0", #COMM
      "iso8583_send_tries"          => "0", #COMM
      "crypto_dukpt_slot"           => "", #SYS
      "ctls"                        => "", #SYS
      "locale"                      => "pt-br", #SYS
      "heartbeat"                   => "", #SYS
      "boot"                        => "1", #SYS
      "company_name"                => "", #SYS
      "metadata_timestamp"          => "",
      "payment_channel_attempts"    => "0",
      "payment_channel_date"        => "",
      "infinitepay_authorizer"      => "0",
      "infinitepay_api"             => "0",
      "infinitepay_cw_endpoint"     => "1",
      "infinitepay_google_endpoint" => "0",
      "transaction_http_enabled"    => "1",
      "transaction_http_host"       => HTTP_HOST_PRODUCTION,
      "transaction_http_port"       => HTTP_PORT,
      "emv_contactless_amount"      => "0",
      "network_init"                => ""
    }

    class << self
      attr_accessor :file
    end

    def self.file
      self.setup unless @file
      @file
    end

    def self.setup
      @file = FileDb.new(FILE_PATH, DEFAULT)
      self.check_environment!
      @file
    end

    def self.check_environment!
      if self.staging?
        self.to_staging!
      else
        self.to_production!
      end
    end

    def self.production?
      self.environment == "production"
    end

    def self.staging?
      self.environment == "staging"
    end

    def self.to_production!
      if self.environment != "production"
        @file.update_attributes("company_name" => "", "environment" => "production", "host" => HOST_PRODUCTION, "transaction_http_host" => HTTP_HOST_PRODUCTION)
        return true
      end
      false
    end

    def self.to_staging!
      if self.environment != "staging"
        @file.update_attributes("company_name" => "", "environment" => "staging", "host" => HOST_STAGING, "transaction_http_host" => HTTP_HOST_STAGING)
        return true
      end
      false
    end

    def self.update_attributes(*args)
      @file.update_attributes(*args)
    end

    def self.method_missing(method, *args, &block)
      setup unless @file
      param = method.to_s
      if @file[param]
        @file[param]
      elsif (param[-1..-1] == "=" && @file[param[0..-2]])
        @file[param[0..-2]] = args.first
      else
        super
      end
    end

    # helper
    def self.payment_channel_set_attempts(time = nil, attempts = nil)
      setup
      if time
        str = "%d-%02d-%02d"
        update_attributes({
          "payment_channel_date"     => (str % [time.year, time.mon, time.day]),
          "payment_channel_attempts" => (attempts || 1)
        })
      else
        update_attributes({
          "payment_channel_attempts" => (attempts || 1)
        })
      end
    end

    # Custom Attributes
    def self.tcp_recv_timeout
      DaFunk::ParamsDat.file["tcp_recv_timeout"] || method_missing(:tcp_recv_timeout)
    end

    def self.attach_gprs_timeout
      value = (DaFunk::ParamsDat.file["attach_gprs_timeout"] || method_missing(:attach_gprs_timeout))
      value.to_s.empty? ? nil : value.to_s.to_i
    end

    def self.heartbeat
      DaFunk::ParamsDat.file["heartbeat"] || method_missing(:heartbeat)
    end

    def self.logical_number
      if self.file["logical_number"].to_s.strip.empty?
        self.file["logical_number"] = Device::System.serial
      else
        self.file["logical_number"]
      end
    end
  end
end

