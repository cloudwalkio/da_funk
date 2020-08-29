module DaFunk
  module Helper
    class StatusBar
      STATUS_TIMEOUT          = 60
      SLOT_MEDIA              = 0
      SLOT_SIGNAL_LEVEL       = 1
      SLOT_UPDATE             = 2
      SLOT_BATTERY_PERCENTUAL = 6
      SLOT_BATTERY_LEVEL      = 7
      SLOT_MESSAGE_CONNECTION = {
        true  => {
          :slot1 => 2,
          :slot2 => 3,
          :message1 => './shared/conectado_01.png',
          :message2 => './shared/conectado_02.png'
        },
        false => {
          :slot1 => 2,
          :slot2 => 3,
          :message1 => './shared/buscando_01.png',
          :message2 => './shared/buscando_02.png'
        }
      }

      BATTERY_IMAGES = {
        0..4     => "./shared/battery0.png",
        5..9     => "./shared/baterry5.png",
        10..19   => "./shared/battery10.png",
        20..29   => "./shared/battery20.png",
        30..39   => "./shared/battery30.png",
        40..49   => "./shared/battery40.png",
        50..59   => "./shared/battery50.png",
        60..69   => "./shared/battery60.png",
        70..79   => "./shared/battery70.png",
        80..89   => "./shared/battery80.png",
        90..99   => "./shared/battery90.png",
        100..100 => "./shared/battery100.png",
      }

      BATTERY_CHARGE_IMAGES = {
        50  => "./shared/battery0c.png",
        100 => "./shared/battery100c.png"
      }

      BATTERY_PERCENTAGE_IMAGES = {
        0..4     => "./shared/battery1_percent.png",
        5..9     => "./shared/battery5_percent.png",
        10..19   => "./shared/battery10_percent.png",
        20..29   => "./shared/battery20_percent.png",
        30..39   => "./shared/battery30_percent.png",
        40..49   => "./shared/battery40_percent.png",
        50..59   => "./shared/battery50_percent.png",
        60..69   => "./shared/battery60_percent.png",
        70..79   => "./shared/battery70_percent.png",
        80..89   => "./shared/battery80_percent.png",
        90..99   => "./shared/battery90_percent.png",
        100..100 => "./shared/battery100_percent.png",
      }

      WIFI_IMAGES = {
        0..0    => "./shared/wifi0.png",
        1..25   => "./shared/wifi25.png",
        26..50  => "./shared/wifi50.png",
        59..75  => "./shared/wifi75.png",
        76..200 => "./shared/wifi100.png"
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
        attr_accessor :signal, :battery, :power, :managment, :connected
      end

      def self.check
        if self.valid?
          self.change_connection
          self.change_battery
          self.change_update
        end
      end

      def self.change_update
        if File.exists?('./shared/system_update')
          PAX::Display.print_status_bar(SLOT_UPDATE, "./shared/system_update_download.png")
          PAX::Display.print_status_bar(3, nil)
          self.connected = false
        else
          change_message
        end
      end

      def self.change_message
        unless File.exists?('./shared/system_update')
          connected = Device::Network.connected?

          if connected != self.connected
            self.connected = connected

            slot_message_1 = SLOT_MESSAGE_CONNECTION[self.connected][:slot1]
            slot_message_2 = SLOT_MESSAGE_CONNECTION[self.connected][:slot2]

            message_1 = SLOT_MESSAGE_CONNECTION[self.connected][:message1]
            message_2 = SLOT_MESSAGE_CONNECTION[self.connected][:message2]

            Device::Display.print_status_bar(slot_message_1, message_1)
            Device::Display.print_status_bar(slot_message_2, message_2)
          end
        end
      end

      def self.change_connection
        if Device::Network.connected?
          sig = Device::Network.signal

          if self.signal != sig
            self.signal = sig

            if Device::Network.gprs?
              Device::Display.print_status_bar(SLOT_MEDIA, "./shared/GPRS.png")
              Device::Display.print_status_bar(SLOT_SIGNAL_LEVEL,
                                               get_image_path(:gprs, self.signal))
            elsif Device::Network.wifi?
              Device::Display.print_status_bar(SLOT_MEDIA, "./shared/WIFI.png")
              Device::Display.print_status_bar(SLOT_SIGNAL_LEVEL,
                                               get_image_path(:wifi, self.signal))
            end
          end
        else
          Device::Display.print_status_bar(SLOT_MEDIA, nil)
          Device::Display.print_status_bar(SLOT_SIGNAL_LEVEL, "./shared/searching.png")
        end
      end

      def self.change_battery
        bat  = Device::System.battery
        dock = Device::System.power_supply

        if self.battery != bat || self.power != dock
          self.battery = bat
          self.power   = dock

          Device::Display.print_status_bar(SLOT_BATTERY_PERCENTUAL,
                                           get_image_path(:battery_percentual, self.battery))
          if self.power
            Device::Display.print_status_bar(
              SLOT_BATTERY_LEVEL, get_image_path(:battery_charge, self.battery))
          else
            Device::Display.print_status_bar(SLOT_BATTERY_LEVEL,
                                             get_image_path(:battery, self.battery))
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
        when :battery_percentual
          BATTERY_PERCENTAGE_IMAGES.each {|k,v| return v if k.include? sig }
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

