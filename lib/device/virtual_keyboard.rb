class Device
  class VirtualKeyboard
    class << self
      attr_accessor :attributes, :type, :text
    end

    self.attributes = {
      :keyboard_capital => [
        {:x => 0..34,  :y => 191..209, :char => 'q'},
        {:x => 0..46,  :y => 191..209, :char => 'w'},
        {:x => 0..65,  :y => 191..209, :char => 'e'},
        {:x => 0..96,  :y => 191..209, :char => 'r'},
        {:x => 0..115, :y => 191..209, :char => 't'},
        {:x => 0..145, :y => 191..209, :char => 'y'},
        {:x => 0..161, :y => 191..209, :char => 'u'},
        {:x => 0..191, :y => 191..209, :char => 'i'},
        {:x => 0..216, :y => 191..209, :char => 'o'},
        {:x => 0..255, :y => 191..209, :char => 'p'},
        {:x => 0..34,  :y => 223..241, :char => 'a'},
        {:x => 0..59,  :y => 223..241, :char => 's'},
        {:x => 0..83,  :y => 223..241, :char => 'd'},
        {:x => 0..106, :y => 223..241, :char => 'f'},
        {:x => 0..131, :y => 223..241, :char => 'g'},
        {:x => 0..153, :y => 223..241, :char => 'h'},
        {:x => 0..178, :y => 223..241, :char => 'j'},
        {:x => 0..201, :y => 223..241, :char => 'k'},
        {:x => 0..230, :y => 223..241, :char => 'l'},
        {:x => 0..30,  :y => 223..273, :char => :keyboard_uppercase},
        {:x => 0..56,  :y => 223..273, :char => 'y'},
        {:x => 0..82,  :y => 223..273, :char => 'x'},
        {:x => 0..109, :y => 223..273, :char => 'c'},
        {:x => 0..130, :y => 223..273, :char => 'v'},
        {:x => 0..154, :y => 223..273, :char => 'b'},
        {:x => 0..176, :y => 223..273, :char => 'n'},
        {:x => 0..201, :y => 223..273, :char => 'm'},
        {:x => 0..240, :y => 223..273, :char => :erase},
        {:x => 0..34,  :y => 223..315, :char => :keyboard_symbol_number},
        {:x => 0..58,  :y => 223..315, :char => '@'},
        {:x => 0..83,  :y => 223..315, :char => ','},
        {:x => 0..148, :y => 223..315, :char => :space},
        {:x => 0..177, :y => 223..315, :char => '.'},
        {:x => 0..255, :y => 223..315, :char => :enter}
      ],

      :keyboard_uppercase => [
        {:x => 0..34,  :y => 191..209, :char => 'Q'},
        {:x => 0..46,  :y => 191..209, :char => 'W'},
        {:x => 0..65,  :y => 191..209, :char => 'E'},
        {:x => 0..96,  :y => 191..209, :char => 'R'},
        {:x => 0..115, :y => 191..209, :char => 'T'},
        {:x => 0..145, :y => 191..209, :char => 'Y'},
        {:x => 0..161, :y => 191..209, :char => 'U'},
        {:x => 0..191, :y => 191..209, :char => 'I'},
        {:x => 0..216, :y => 191..209, :char => 'O'},
        {:x => 0..255, :y => 191..209, :char => 'P'},
        {:x => 0..34,  :y => 223..241, :char => 'A'},
        {:x => 0..59,  :y => 223..241, :char => 'S'},
        {:x => 0..83,  :y => 223..241, :char => 'D'},
        {:x => 0..106, :y => 223..241, :char => 'F'},
        {:x => 0..131, :y => 223..241, :char => 'G'},
        {:x => 0..153, :y => 223..241, :char => 'H'},
        {:x => 0..178, :y => 223..241, :char => 'J'},
        {:x => 0..201, :y => 223..241, :char => 'K'},
        {:x => 0..230, :y => 223..241, :char => 'L'},
        {:x => 0..30,  :y => 223..273, :char => :keyboard_capital},
        {:x => 0..56,  :y => 223..273, :char => 'Y'},
        {:x => 0..82,  :y => 223..273, :char => 'X'},
        {:x => 0..109, :y => 223..273, :char => 'C'},
        {:x => 0..130, :y => 223..273, :char => 'V'},
        {:x => 0..154, :y => 223..273, :char => 'B'},
        {:x => 0..176, :y => 223..273, :char => 'N'},
        {:x => 0..201, :y => 223..273, :char => 'M'},
        {:x => 0..240, :y => 223..273, :char => :erase},
        {:x => 0..34,  :y => 223..315, :char => :keyboard_symbol_number},
        {:x => 0..58,  :y => 223..315, :char => '@'},
        {:x => 0..83,  :y => 223..315, :char => ','},
        {:x => 0..148, :y => 223..315, :char => :space},
        {:x => 0..177, :y => 223..315, :char => '.'},
        {:x => 0..255, :y => 223..315, :char => :enter}
      ],

      :keyboard_symbol_number => [
        {:x => 0..35,  :y => 190..210, :char => '('},
        {:x => 0..68,  :y => 190..210, :char => ')'},
        {:x => 0..104, :y => 190..210, :char => '1'},
        {:x => 0..138, :y => 190..210, :char => '2'},
        {:x => 0..169, :y => 190..210, :char => '3'},
        {:x => 0..203, :y => 190..210, :char => '+'},
        {:x => 0..239, :y => 190..210, :char => '-'},
        {:x => 0..35,  :y => 220..245, :char => '?'},
        {:x => 0..68,  :y => 220..245, :char => '$'},
        {:x => 0..104, :y => 220..245, :char => '4'},
        {:x => 0..138, :y => 220..245, :char => '5'},
        {:x => 0..169, :y => 220..245, :char => '6'},
        {:x => 0..203, :y => 220..245, :char => '*'},
        {:x => 0..239, :y => 220..245, :char => '/'},
        {:x => 0..35,  :y => 255..275, :char => '!'},
        {:x => 0..68,  :y => 255..275, :char => ';'},
        {:x => 0..104, :y => 255..275, :char => '7'},
        {:x => 0..138, :y => 255..275, :char => '8'},
        {:x => 0..169, :y => 255..275, :char => '9'},
        {:x => 0..203, :y => 255..275, :char => '='},
        {:x => 0..239, :y => 255..275, :char => :erase},
        {:x => 0..35,  :y => 290..315, :char => :keyboard_capital},
        {:x => 0..68,  :y => 290..315, :char => '@'},
        {:x => 0..104, :y => 290..315, :char => '%'},
        {:x => 0..138, :y => 290..315, :char => '0'},
        {:x => 0..169, :y => 290..315, :char => '#'},
        {:x => 0..203, :y => 290..315, :char => '_'},
        {:x => 0..239, :y => 290..315, :char => :enter}
      ],
    }

    def self.type_text(options = {})
      timeout, self.text = set_parameters(options)

      loop do
        break(Device::IO::KEY_TIMEOUT) if Time.now > timeout

        x, y = getxy_stream(100)
        if x && y
          touch_clear

          key = self.attributes[self.type].select {|v| v[:x].include?(x) && v[:y].include?(y)}
          break(self.text) if parse(key, options) == :enter
        elsif getc(100) == Device::IO::CANCEL
          break(Device::IO::CANCEL)
        end
      end
    end

    def self.parse(key, options)
      return if key.empty?

      Device::Audio.beep(7, 60)
      key = key.first

      if change_keyboard?(key[:char])
        self.type = key[:char]
        change_keyboard
      elsif key_erase?(key[:char])
        Device::Display.clear options[:line]
        self.text = self.text[0..-2]
      elsif key_space?(key[:char])
        self.text += ' '
      elsif ! key_enter?(key[:char])
        self.text << key[:char]
      end
      Device::Display.print_line("#{self.text}", options[:line], options[:column])

      key[:char]
    end

    def self.key_erase?(key)
      key == :erase
    end

    def self.key_space?(key)
      key == :space
    end

    def self.key_enter?(key)
      key == :enter
    end

    def self.change_keyboard
      Device::Display.print_bitmap("./shared/#{self.type.to_s}.bmp")
    end

    def self.change_keyboard?(key)
      [:keyboard_uppercase, :keyboard_symbol_number, :keyboard_capital].include?(key)
    end

    def self.set_parameters(options)
      self.type        = :keyboard_capital
      options[:line]   = options[:line] || 3
      options[:column] = options[:column] || 0
      Device::Display.clear
      change_keyboard

      [Time.now + (options[:timeout] || Device::IO.timeout) / 1000, options[:text] || '']
    end
  end
end
