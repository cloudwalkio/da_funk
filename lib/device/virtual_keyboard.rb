# frozen_string_literal: true

class Device
  class VirtualKeyboard
    class << self
      attr_accessor :attributes, :type, :text
    end

    self.attributes = {
      keyboard_capital: [
        { x: 0..34,  y: 191..209, char: 'q' },
        { x: 0..46,  y: 191..209, char: 'w' },
        { x: 0..65,  y: 191..209, char: 'e' },
        { x: 0..96,  y: 191..209, char: 'r' },
        { x: 0..115, y: 191..209, char: 't' },
        { x: 0..145, y: 191..209, char: 'y' },
        { x: 0..161, y: 191..209, char: 'u' },
        { x: 0..191, y: 191..209, char: 'i' },
        { x: 0..216, y: 191..209, char: 'o' },
        { x: 0..255, y: 191..209, char: 'p' },
        { x: 0..34,  y: 223..241, char: 'a' },
        { x: 0..59,  y: 223..241, char: 's' },
        { x: 0..83,  y: 223..241, char: 'd' },
        { x: 0..106, y: 223..241, char: 'f' },
        { x: 0..131, y: 223..241, char: 'g' },
        { x: 0..153, y: 223..241, char: 'h' },
        { x: 0..178, y: 223..241, char: 'j' },
        { x: 0..201, y: 223..241, char: 'k' },
        { x: 0..230, y: 223..241, char: 'l' },
        { x: 0..30,  y: 223..273, char: :keyboard_uppercase },
        { x: 0..56,  y: 223..273, char: 'z' },
        { x: 0..82,  y: 223..273, char: 'x' },
        { x: 0..109, y: 223..273, char: 'c' },
        { x: 0..130, y: 223..273, char: 'v' },
        { x: 0..154, y: 223..273, char: 'b' },
        { x: 0..176, y: 223..273, char: 'n' },
        { x: 0..201, y: 223..273, char: 'm' },
        { x: 0..240, y: 223..273, char: :erase },
        { x: 0..34,  y: 223..315, char: :keyboard_symbol_number },
        { x: 0..58,  y: 223..315, char: '@' },
        { x: 0..83,  y: 223..315, char: ',' },
        { x: 0..148, y: 223..315, char: :space },
        { x: 0..177, y: 223..315, char: '.' },
        { x: 0..255, y: 223..315, char: :enter }
      ],

      keyboard_uppercase: [
        { x: 0..34,  y: 191..209, char: 'Q' },
        { x: 0..46,  y: 191..209, char: 'W' },
        { x: 0..65,  y: 191..209, char: 'E' },
        { x: 0..96,  y: 191..209, char: 'R' },
        { x: 0..115, y: 191..209, char: 'T' },
        { x: 0..145, y: 191..209, char: 'Y' },
        { x: 0..161, y: 191..209, char: 'U' },
        { x: 0..191, y: 191..209, char: 'I' },
        { x: 0..216, y: 191..209, char: 'O' },
        { x: 0..255, y: 191..209, char: 'P' },
        { x: 0..34,  y: 223..241, char: 'A' },
        { x: 0..59,  y: 223..241, char: 'S' },
        { x: 0..83,  y: 223..241, char: 'D' },
        { x: 0..106, y: 223..241, char: 'F' },
        { x: 0..131, y: 223..241, char: 'G' },
        { x: 0..153, y: 223..241, char: 'H' },
        { x: 0..178, y: 223..241, char: 'J' },
        { x: 0..201, y: 223..241, char: 'K' },
        { x: 0..230, y: 223..241, char: 'L' },
        { x: 0..30,  y: 223..273, char: :keyboard_capital },
        { x: 0..56,  y: 223..273, char: 'Z' },
        { x: 0..82,  y: 223..273, char: 'X' },
        { x: 0..109, y: 223..273, char: 'C' },
        { x: 0..130, y: 223..273, char: 'V' },
        { x: 0..154, y: 223..273, char: 'B' },
        { x: 0..176, y: 223..273, char: 'N' },
        { x: 0..201, y: 223..273, char: 'M' },
        { x: 0..240, y: 223..273, char: :erase },
        { x: 0..34,  y: 223..315, char: :keyboard_symbol_number },
        { x: 0..58,  y: 223..315, char: '@' },
        { x: 0..83,  y: 223..315, char: ',' },
        { x: 0..148, y: 223..315, char: :space },
        { x: 0..177, y: 223..315, char: '.' },
        { x: 0..255, y: 223..315, char: :enter }
      ],

      keyboard_symbol_number: [
        { x: 0..34,  y: 191..209, char: '1' },
        { x: 0..46,  y: 191..209, char: '2' },
        { x: 0..65,  y: 191..209, char: '3' },
        { x: 0..96,  y: 191..209, char: '4' },
        { x: 0..115, y: 191..209, char: '5' },
        { x: 0..145, y: 191..209, char: '6' },
        { x: 0..161, y: 191..209, char: '7' },
        { x: 0..191, y: 191..209, char: '8' },
        { x: 0..216, y: 191..209, char: '9' },
        { x: 0..255, y: 191..209, char: '0' },
        { x: 0..31,  y: 223..241, char: '%' },
        { x: 0..52,  y: 223..241, char: '#' },
        { x: 0..77,  y: 223..241, char: '$' },
        { x: 0..97,  y: 223..241, char: '_' },
        { x: 0..121, y: 223..241, char: '&' },
        { x: 0..143, y: 223..241, char: '-' },
        { x: 0..168, y: 223..241, char: '+' },
        { x: 0..186, y: 223..241, char: '(' },
        { x: 0..215, y: 223..241, char: ')' },
        { x: 0..236, y: 223..241, char: '/' },
        { x: 0..42,  y: 223..274, char: :keyboard_symbol_number_2 },
        { x: 0..60,  y: 223..274, char: '*' },
        { x: 0..84,  y: 223..274, char: '"' },
        { x: 0..107, y: 223..274, char: "'" },
        { x: 0..130, y: 223..274, char: ':' },
        { x: 0..152, y: 223..274, char: ';' },
        { x: 0..171, y: 223..274, char: '!' },
        { x: 0..197, y: 223..274, char: '?' },
        { x: 0..255, y: 223..274, char: :erase },
        { x: 0..36,  y: 223..315, char: :keyboard_capital },
        { x: 0..63,  y: 223..315, char: '@' },
        { x: 0..88,  y: 223..315, char: ',' },
        { x: 0..152, y: 223..315, char: :space },
        { x: 0..168, y: 223..315, char: '.' },
        { x: 0..255, y: 223..315, char: :enter }
      ],

      keyboard_symbol_number_2: [
        { x: 0..34,  y: 191..209, char: '1' },
        { x: 0..46,  y: 191..209, char: '2' },
        { x: 0..69,  y: 191..209, char: '3' },
        { x: 0..96,  y: 191..209, char: '4' },
        { x: 0..115, y: 191..209, char: '5' },
        { x: 0..145, y: 191..209, char: '6' },
        { x: 0..161, y: 191..209, char: '7' },
        { x: 0..191, y: 191..209, char: '8' },
        { x: 0..216, y: 191..209, char: '9' },
        { x: 0..255, y: 191..209, char: '0' },
        { x: 0..35,  y: 223..241, char: '^' },
        { x: 0..63,  y: 223..241, char: '[' },
        { x: 0..97,  y: 223..241, char: ']' },
        { x: 0..128, y: 223..241, char: '{' },
        { x: 0..158, y: 223..241, char: '}' },
        { x: 0..193, y: 223..241, char: '<' },
        { x: 0..255, y: 223..241, char: '>' },
        { x: 0..39,  y: 223..274, char: :keyboard_symbol_number },
        { x: 0..63,  y: 223..274, char: '\\' },
        { x: 0..86,  y: 223..274, char: '-' },
        { x: 0..106, y: 223..274, char: '+' },
        { x: 0..130, y: 223..274, char: '=' },
        { x: 0..149, y: 223..274, char: '_' },
        { x: 0..175, y: 223..274, char: '˜' },
        { x: 0..195, y: 223..274, char: '|' },
        { x: 0..255, y: 223..274, char: :erase },
        { x: 0..34,  y: 223..310, char: :keyboard_capital },
        { x: 0..61,  y: 223..310, char: '@' },
        { x: 0..87,  y: 223..310, char: ',' },
        { x: 0..146, y: 223..313, char: :space },
        { x: 0..168, y: 223..311, char: '.' },
        { x: 0..194, y: 223..319, char: :enter }
      ]
    }

    def self.type_text(params = {})
      phisical_keys = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', "\017"]
      change_keyboard
      Device::Display.print_line("#{self.text}", params[:line], params[:column])
      if params[:timeout_enabled]
        time = Time.now + (params[:timeout] || Device::IO.timeout) / 1000
      end

      key = nil
      while text_not_ready?(key)
        line_x, line_y = getxy_stream(100)

        if line_x && line_y
          touch_clear
          key = parse(line_x, line_y, params)
        else
          if params[:timeout_enabled]
            break(Device::IO::KEY_TIMEOUT) if Time.now > time
          end
          key = getc(100)
          if phisical_keys.include?(key)
            if key == Device::IO::BACK
              show_text({char: :erase}, params)
            else
              show_text({char: key}, params)
            end
          end
        end
      end

      [key, self.text]
    end

    def self.text_not_ready?(key)
      key != :enter && key != Device::IO::ENTER && key != Device::IO::CANCEL
    end

    def self.parse(line_x, line_y, params)
      key = attributes[type].find do |value|
        value[:x].include?(line_x) && value[:y].include?(line_y)
      end
      return if key.nil?

      Device::Audio.beep(7, 60)
      show_text(key, params)

      key[:char]
    end

    def self.show_text(key, params)
      case key[:char]
      when :keyboard_uppercase, :keyboard_symbol_number, :keyboard_symbol_number_2, :keyboard_capital
        self.type = key[:char]
        change_keyboard
      when :erase
        self.text += '' if text.nil?
        self.text = text[0..-2]
      when :space
        self.text += ' '
      else
        if self.text && self.text.size < 20
          self.text << key[:char] unless key[:char] == :enter
        end
      end
      Device::Display.print_line("#{self.text}", params[:line], params[:column])
    end

    def self.change_keyboard
      if type.nil?
        self.type = :keyboard_capital
        Device::Display.print_bitmap('./shared/keyboard_capital.bmp')
      else
        Device::Display.print_bitmap("./shared/#{type}.bmp")
      end
    end

    def self.wifi_password
      self.text = if Device::Setting.wifi_password == 'false'
                    ''
                  else
                    Device::Setting.wifi_password
                  end
    end
  end
end
