module DaFunk
  module Helper
    class StatusBar
      STATUS_TIMEOUT  = 60
      SLOT_CONNECTION = 0
      SLOT_BATTERY    = 7
      SLOT_LINK       = 1
      SLOT_UPDATE     = 2

      BATTERY_IMAGES = {
        0..24    => "./shared/battery0.png",
        25..49   => "./shared/battery25.png",
        50..74   => "./shared/battery50.png",
        75..99   => "./shared/battery75.png",
        100..100 => "./shared/battery100.png"
      }

      BATTERY_CHARGE_IMAGES = {
        50  => "./shared/battery0c.png",
        100 => "./shared/battery100c.png"
      }

      WIFI_IMAGES = {
        0..29   => "./shared/wifi0.png",
        30..59  => "./shared/wifi30.png",
        60..79  => "./shared/wifi60.png",
        80..200 => "./shared/wifi100.png"
      }

      MOBILE_IMAGES = {
        0..0    => "./shared/mobile0.png",
        1..20   => "./shared/mobile20.png",
        21..40  => "./shared/mobile40.png",
        41..60  => "./shared/mobile60.png",
        61..80  => "./shared/mobile80.png",
        81..200 => "./shared/mobile100.png"
      }

      class << self
        attr_accessor :signal, :battery, :power, :managment, :link
      end

      def self.check
        if self.valid?
          self.change_connection
          self.change_battery
          self.change_link
          self.change_update
        end
      end

      def self.change_update
        if File.exists?('./shared/system_update')
          PAX::Display.print_status_bar(SLOT_UPDATE, "./shared/system_update_download.png")
        else
          PAX::Display.print_status_bar(SLOT_UPDATE, nil)
        end
      end

      def self.change_link
        if Device::Network.connected?
          if DaFunk::PaymentChannel.alive?
            PAX::Display.print_status_bar(SLOT_LINK, "./shared/link.png")
          else
            PAX::Display.print_status_bar(SLOT_LINK, "./shared/unlink.png")
          end
        else
          PAX::Display.print_status_bar(SLOT_LINK, "./shared/unlink.png")
        end
      end

      def self.change_connection
        sig = Device::Network.signal
        if self.signal != sig
          self.signal = sig
          if Device::Network.gprs?
            Device::Display.print_status_bar(SLOT_CONNECTION,
                                             get_image_path(:gprs, self.signal))
          elsif Device::Network.wifi?
            Device::Display.print_status_bar(SLOT_CONNECTION,
                                             get_image_path(:wifi, self.signal))
          end
        end
      end

      def self.change_battery
        bat  = Device::System.battery
        dock = Device::System.power_supply
        if self.battery != bat || self.power != dock
          self.battery = bat
          self.power   = dock
          if self.power
            Device::Display.print_status_bar(
              SLOT_BATTERY, get_image_path(:battery_charge, self.battery))
          else
            Device::Display.print_status_bar(
              SLOT_BATTERY, get_image_path(:battery, self.battery))
          end
        end
      end

      def self.get_image_path(type, sig)
        return if sig.nil?
        case type
        when :gprs
          MOBILE_IMAGES.each {|k,v| return v if k.include? sig }
        when :wifi
          WIFI_IMAGES.each {|k,v| return v if k.include? sig }
        when :battery
          BATTERY_IMAGES.each {|k,v| return v if k.include? sig }
        when :battery_charge
          BATTERY_CHARGE_IMAGES[sig]
        else
          nil
        end
      end

      self.managment      ||= true
      def self.valid?
        if self.managment
          true
        end
      end
    end
  end
end

