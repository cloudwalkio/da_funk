#
# @file status_bar.rb
# @brief DaFunk status bar helper script.
# @platform N/A
#
# @copyright Copyright (c) 2016 CloudWalk, Inc.
#

module DaFunk
  module Helper
    # Status bar class definition.
    class StatusBar
      # Class macros and constants
      STATUS_TIMEOUT = 60
      SLOT_MEDIA = 0
      SLOT_SIGNAL_LEVEL = 1
      SLOT_UPDATE = 2
      SLOT_BATTERY_PERCENTUAL = 6
      SLOT_BATTERY_LEVEL = 7

      # TODO: review the 'print_status_bar' API to reduce the number of files
      # to eleven?
      BATTERY_PERCENTAGE_IMAGES = [
         './shared/1%.png',  './shared/1%.png',  './shared/2%.png',
         './shared/3%.png',  './shared/4%.png',  './shared/5%.png',
         './shared/6%.png',  './shared/7%.png',  './shared/8%.png',
         './shared/9%.png', './shared/10%.png', './shared/11%.png',
        './shared/12%.png', './shared/13%.png', './shared/14%.png',
        './shared/15%.png', './shared/16%.png', './shared/17%.png',
        './shared/18%.png', './shared/19%.png', './shared/20%.png',
        './shared/21%.png', './shared/22%.png', './shared/23%.png',
        './shared/24%.png', './shared/25%.png', './shared/26%.png',
        './shared/27%.png', './shared/28%.png', './shared/29%.png',
        './shared/30%.png', './shared/31%.png', './shared/32%.png',
        './shared/33%.png', './shared/34%.png', './shared/35%.png',
        './shared/36%.png', './shared/37%.png', './shared/38%.png',
        './shared/39%.png', './shared/40%.png', './shared/41%.png',
        './shared/42%.png', './shared/43%.png', './shared/44%.png',
        './shared/45%.png', './shared/46%.png', './shared/47%.png',
        './shared/48%.png', './shared/49%.png', './shared/50%.png',
        './shared/51%.png', './shared/52%.png', './shared/53%.png',
        './shared/54%.png', './shared/55%.png', './shared/56%.png',
        './shared/57%.png', './shared/58%.png', './shared/59%.png',
        './shared/60%.png', './shared/61%.png', './shared/62%.png',
        './shared/63%.png', './shared/64%.png', './shared/65%.png',
        './shared/66%.png', './shared/67%.png', './shared/68%.png',
        './shared/69%.png', './shared/70%.png', './shared/71%.png',
        './shared/72%.png', './shared/73%.png', './shared/74%.png',
        './shared/75%.png', './shared/76%.png', './shared/77%.png',
        './shared/78%.png', './shared/79%.png', './shared/80%.png',
        './shared/81%.png', './shared/82%.png', './shared/83%.png',
        './shared/84%.png', './shared/85%.png', './shared/86%.png',
        './shared/87%.png', './shared/88%.png', './shared/89%.png',
        './shared/90%.png', './shared/91%.png', './shared/92%.png',
        './shared/93%.png', './shared/94%.png', './shared/95%.png',
        './shared/96%.png', './shared/97%.png', './shared/98%.png',
        './shared/99%.png', './shared/100%.png'
      ].freeze

      MEDIA_PATH = {
        :gprs => './shared/3G.png',
        :wifi => './shared/WIFI.png'
      }

      BATTERY_CHARGING = [
        "./shared/battery_charging.png",
        "./shared/battery_charged.png"
      ].freeze

      BATTERY_IMAGES = {
        0..4     => "./shared/battery0.png",
        5..19    => "./shared/battery10.png",
        20..29   => "./shared/battery20.png",
        30..39   => "./shared/battery30.png",
        40..49   => "./shared/battery40.png",
        50..59   => "./shared/battery50.png",
        60..69   => "./shared/battery60.png",
        70..79   => "./shared/battery70.png",
        80..89   => "./shared/battery80.png",
        90..99   => "./shared/battery90.png",
        100..100 => "./shared/battery100.png"
      }

      WIFI_IMAGES = {
        0..0     => "./shared/wifi0.png",
        1..25    => "./shared/wifi25.png",
        26..50   => "./shared/wifi50.png",
        59..75   => "./shared/wifi75.png",
        76..200  => "./shared/wifi100.png"
      }

      MOBILE_IMAGES = {
        0..0     => "./shared/mobile0.png",
        1..20    => "./shared/mobile20.png",
        21..40   => "./shared/mobile40.png",
        41..60   => "./shared/mobile60.png",
        61..80   => "./shared/mobile80.png",
        81..200  => "./shared/mobile100.png"
      }

      class << self
        attr_accessor :current_signal, :current_message, :battery, :power, :managment
        attr_accessor :current_media
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
        else
          self.change_message
        end
      end

      def self.change_message
        if ThreadScheduler.pause?(ThreadScheduler::THREAD_EXTERNAL_COMMUNICATION, 200)
          if self.current_message != :pause
            self.current_message = :pause
            Device::Display.print_status_bar(2, './shared/semsinal_01.png')
            Device::Display.print_status_bar(3, './shared/semsinal_02.png')
          end
        elsif Device::Network.connected?
          if self.current_message != :connected
            self.current_message = :connected
            Device::Display.print_status_bar(2, './shared/conectado_01.png')
            Device::Display.print_status_bar(3, './shared/conectado_02.png')
          end
        else
          if self.current_message != :searching
            self.current_message = :searching
            Device::Display.print_status_bar(2, './shared/buscando_01.png')
            Device::Display.print_status_bar(3, './shared/buscando_02.png')
          end
        end
      end

      def self.change_connection
        if ThreadScheduler.pause?(ThreadScheduler::THREAD_EXTERNAL_COMMUNICATION, 200)
          Device::Display.print_status_bar(SLOT_MEDIA, nil)
          Device::Display.print_status_bar(SLOT_SIGNAL_LEVEL, nil)
          self.current_media = nil
          self.current_signal = nil
        elsif Device::Network.connected?
          media  = Device::Network.gprs? ? :gprs : :wifi
          signal = Device::Network.signal
          if media != self.current_media
            self.current_media = media
            Device::Display.print_status_bar(SLOT_MEDIA, MEDIA_PATH[self.current_media])
          end
          if signal != self.current_signal
            self.current_signal = signal
            Device::Display.print_status_bar(SLOT_SIGNAL_LEVEL,
                                              self.get_image_path(self.current_media, self.current_signal))
          end
        else
          Device::Display.print_status_bar(SLOT_MEDIA, nil)
          Device::Display.print_status_bar(SLOT_SIGNAL_LEVEL, "./shared/searching.png")
          self.current_media = nil
          self.current_signal = nil
        end
      end

      # Updates the battery slot whenever a capacity or power supply change is
      # detected.
      def self.change_battery
        capacity_type = Device::System.battery_capacity_type

        capacity = Device::System.battery
        charging = Device::System.power_supply

        if self.battery != capacity || self.power != charging

          if self.battery.nil? # basic integrity check
            self.battery = capacity
          elsif charging
            capacity >= self.battery && self.battery = capacity
          else
            capacity <= self.battery && self.battery = capacity
          end

          if self.power == charging && capacity != self.battery
            return nil
          end

          self.power = charging

          rsc = self.get_image_path(self.power ? :battery_charge : :battery, self.battery)

          Device::Display.print_status_bar(SLOT_BATTERY_LEVEL, rsc)

          if capacity_type == 'percentage' || !self.power
            rsc = self.get_image_path(:battery_percentual, self.battery)
          else
            rsc = nil
          end

          Device::Display.print_status_bar(SLOT_BATTERY_PERCENTUAL, rsc)
        end
      end

      # Searches for the correspondent image to 'type' and 'signal strength'.
      def self.get_image_path(type, sig)
        return if sig.nil?
        case type
        when :gprs
          MOBILE_IMAGES.each do |k, v|
            return v if k.include? sig
          end
        when :wifi
          WIFI_IMAGES.each do |k, v|
            return v if k.include? sig
          end
        when :battery
          BATTERY_IMAGES.each do |k, v|
            return v if k.include? sig
          end
        when :battery_charge
          if sig < 100
            BATTERY_CHARGING[0]
          else
            BATTERY_CHARGING[1]
          end
        when :battery_percentual
          BATTERY_PERCENTAGE_IMAGES[sig]
        else
          nil
        end
      end

      self.managment ||= true
      def self.valid?
        if self.managment
          true
        end
      end
    end
  end
end
