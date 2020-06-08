class Device
  class VirtualKeyboard
    class << self
      attr_accessor :attributes, :type
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
        {:x => 0..238, :y => 223..273, :char => :erase},
        {:x => 0..34,  :y => 223..319, :char => :keyboard_symbol_number},
        {:x => 0..58,  :y => 223..319, :char => '@'},
        {:x => 0..83,  :y => 223..319, :char => ','},
        {:x => 0..148, :y => 223..319, :char => :space},
        {:x => 0..177, :y => 223..319, :char => '.'},
        {:x => 0..255, :y => 223..319, :char => :enter}
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
        {:x => 0..238, :y => 223..273, :char => :erase},
        {:x => 0..34,  :y => 223..319, :char => :keyboard_symbol_number},
        {:x => 0..58,  :y => 223..319, :char => '@'},
        {:x => 0..83,  :y => 223..319, :char => ','},
        {:x => 0..148, :y => 223..319, :char => :space},
        {:x => 0..177, :y => 223..319, :char => '.'},
        {:x => 0..255, :y => 223..319, :char => :enter}
      ],

      :keyboard_symbol_number => [
        {:x => 0..34,  :y => 191..209, :char => nil},
        {:x => 0..46,  :y => 191..209, :char => nil},
        {:x => 0..65,  :y => 191..209, :char => nil},
        {:x => 0..96,  :y => 191..209, :char => nil},
        {:x => 0..115, :y => 191..209, :char => nil},
        {:x => 0..145, :y => 191..209, :char => nil},
        {:x => 0..161, :y => 191..209, :char => nil},
        {:x => 0..191, :y => 191..209, :char => nil},
        {:x => 0..216, :y => 191..209, :char => nil},
        {:x => 0..255, :y => 191..209, :char => nil},
        {:x => 0..34,  :y => 223..241, :char => nil},
        {:x => 0..59,  :y => 223..241, :char => nil},
        {:x => 0..83,  :y => 223..241, :char => nil},
        {:x => 0..106, :y => 223..241, :char => nil},
        {:x => 0..131, :y => 223..241, :char => nil},
        {:x => 0..153, :y => 223..241, :char => nil},
        {:x => 0..178, :y => 223..241, :char => nil},
        {:x => 0..201, :y => 223..241, :char => nil},
        {:x => 0..230, :y => 223..241, :char => nil},
        {:x => 0..30,  :y => 223..273, :char => nil},
        {:x => 0..56,  :y => 223..273, :char => nil},
        {:x => 0..82,  :y => 223..273, :char => nil},
        {:x => 0..109, :y => 223..273, :char => nil},
        {:x => 0..130, :y => 223..273, :char => nil},
        {:x => 0..154, :y => 223..273, :char => nil},
        {:x => 0..176, :y => 223..273, :char => nil},
        {:x => 0..201, :y => 223..273, :char => nil},
        {:x => 0..238, :y => 223..273, :char => nil},
        {:x => 0..34,  :y => 223..319, :char => nil},
        {:x => 0..58,  :y => 223..319, :char => nil},
        {:x => 0..83,  :y => 223..319, :char => nil},
        {:x => 0..148, :y => 223..319, :char => nil},
        {:x => 0..177, :y => 223..319, :char => nil},
        {:x => 0..255, :y => 223..319, :char => nil}
      ],
    }

    def self.type_text(options = {})
      Device::Display.clear
      text    = options[:text] || ''
      timeout = Time.now + (options[:timeout] || Device::IO.timeout) / 1000
      set_parameters(options)

      loop do
        break(Device::IO::KEY_TIMEOUT) if Time.now > timeout

        x, y = getxy_stream(100)
        if x && y
          touch_clear
          key = self.attributes[self.type].select {|v| v[:x].include?(x) && v[:y].include?(y)}

          unless key.empty?
            Device::Audio.beep(7, 60)
            key = key.first

            if change_keyboard?(key[:char])
              self.type = key[:char]
              change_keyboard
            elsif key[:char] == :erase
              Device::Display.clear options[:line]
              text = text[0..-2]
            elsif key[:char] == :space
              text += ' '
            elsif key[:char] == :enter
              break(text)
            else
              text << key[:char]
            end
          end
          Device::Display.clear options[:line]
          Device::Display.print_line(text, options[:line], options[:column])
        elsif getc(100) == Device::IO::CANCEL
          break(Device::IO::CANCEL)
        end
      end
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
      change_keyboard
    end
  end
end
