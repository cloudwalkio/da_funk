class Device
  class IO < ::IO
    include DaFunk::Helper

    F1               = "\001"
    F2               = "\002"
    F3               = "\003"
    F4               = "\004"
    FUNC             = "\006"
    UP               = "\007"
    DOWN             = "\008"
    MENU             = "\009"
    ENTER            = 0x0D.chr
    CLEAR            = 0x0F.chr
    ALPHA            = 0x10.chr
    SHARP            = 0x11.chr
    KEY_TIMEOUT      = 0x12.chr
    BACK             = "\017"
    CANCEL           = 0x1B.chr
    IO_INPUT_NUMBERS = :numbers
    IO_INPUT_LETTERS = :letters
    IO_INPUT_ALPHA   = :alpha
    IO_INPUT_SECRET  = :secret
    IO_INPUT_DECIMAL = :decimal
    IO_INPUT_MONEY   = :money
    IO_INPUT_MASK    = :mask

    MASK_ALPHA       = :alpha
    MASK_LETTERS     = :letters
    MASK_NUMBERS     = :number

    DEFAULT_TIMEOUT  = 30000

    NUMBERS = %w(1 2 3 4 5 6 7 8 9 0)

    ONE_NUMBER    = "1"
    TWO_NUMBER    = "2"
    THREE_NUMBER  = "3"
    FOUR_NUMBER   = "4"
    FIVE_NUMBER   = "5"
    SIX_NUMBER    = "6"
    SEVEN_NUMBER  = "7"
    EIGHT_NUMBER  = "8"
    NINE_NUMBER   = "9"
    ZERO_NUMBER   = "0"

    KEYBOARD_DEFAULT = ["qzQZ.", "abcABC", "defDEF", "ghiGHI", "jklJKL",
      "mnoMNO", "prsPRS", "tuvTUV", "wxyWXY", ", *\#_$%-+="]

    class << self
      attr_accessor :timeout, :keys_range, :forward_key, :back_key, :back_key_label,
        :forward_key_label, :keys_valid
    end

    # Setup Keyboard Map
    #
    # @param map [Array] contains the key map from 1 to 0 (0..9)
    # @return [NilClass] nil.
    #
    # @example
    #   one_letters   = "qzQZ _,."
    #   two_letters   = "abcABC"
    #   three_letters = "defDEF"
    #   four_letters  = "ghiGHI"
    #   five_letters  = "jklJKL"
    #   six_letters   = "mnoMNO"
    #   seven_letters = "prsPRS"
    #   eight_letters = "tuvTUV"
    #   nine_letters  = "wxyWXY"
    #   zero_letters  = "spSP"
    #   map = [one_letters, two_letters, three_letters, four_letters, five_letters,
    #   six_letters, seven_letters, eight_letters, nine_letters, zero_letters]
    #   Device::IO.setup_keyboard(map)
    def self.setup_keyboard(map, options = {})
      one_letters, two_letters, three_letters, four_letters, five_letters,
        six_letters, seven_letters, eight_letters, nine_letters, zero_letters =
        map

      range_number  = [
        ONE_NUMBER , TWO_NUMBER   , THREE_NUMBER , FOUR_NUMBER , FIVE_NUMBER ,
        SIX_NUMBER , SEVEN_NUMBER , EIGHT_NUMBER , NINE_NUMBER , ZERO_NUMBER
      ]
      range_letters = [
        one_letters, two_letters, three_letters, four_letters, five_letters,
        six_letters, seven_letters, eight_letters, nine_letters, zero_letters
      ]
      range_alpha = [
        ONE_NUMBER   + one_letters, TWO_NUMBER     + two_letters,
        THREE_NUMBER + three_letters, FOUR_NUMBER  + four_letters,
        FIVE_NUMBER  + five_letters, SIX_NUMBER    + six_letters,
        SEVEN_NUMBER + seven_letters, EIGHT_NUMBER + eight_letters,
        NINE_NUMBER  + nine_letters, ZERO_NUMBER   + zero_letters
      ]
      @keys_range = {MASK_ALPHA => range_alpha, MASK_LETTERS => range_letters, MASK_NUMBERS => range_number}
      @keys_valid = range_alpha.flatten.join

      self.back_key          = options[:back_key]          || Device::IO::F1
      self.back_key_label    = options[:back_key_label]    || " F1 "
      self.forward_key       = options[:forward_key]       || Device::IO::F2
      self.forward_key_label = options[:forward_key_label] || " F2 "
    end

    self.setup_keyboard(KEYBOARD_DEFAULT)
    self.timeout = DEFAULT_TIMEOUT

    # Restricted to terminals, get strings and numbers.
    # The switch method between uppercase, lowercase and number characters is to keep pressing a same button quickly. The timeout of this operation is 1 second.
    #
    # @param min [Fixnum] Minimum length of the input string.
    # @param max [Fixnum] Maximum length of the input string (127 bytes maximum).
    # @param options [Hash]
    #
    # :value - Represent the current value, to be initially used.
    #
    # :precision - Sets the level of precision (defaults to 2).
    #
    # :separator - Sets the separator between the units (defaults to “.”).
    #
    # :delimiter - Sets the thousands delimiter (defaults to “,”).
    #
    # :label - Sets the label display before currency, eg.: "U$:", "R$:"
    #
    # :mask - If mode IO_INPUT_MASK a mask should send
    #   (only numbers and letters are allowed), eg.: "9999-AAAA"
    #
    # :mode - Define input modes:
    #
    #   :numbers (IO_INPUT_NUMBERS) - Only number.
    #   :letters (IO_INPUT_LETTERS) - Only Letters.
    #   :alpha (IO_INPUT_ALPHA) - Letters and numbers.
    #   :secret (IO_INPUT_SECRET) - Secret *.
    #   :decimal (IO_INPUT_DECIMAL) - Decimal input, only number.
    #   :money (IO_INPUT_MONEY) - Money input, only number.
    #   :mask (IO_INPUT_MASK) - Custom mask.
    #
    # @return [String] buffer read from keyboard
    def self.get_format(min, max, options = {})
      set_default_format_option(options)
      key = text = options[:value] || ""

      while key != CANCEL
        Device::Display.clear options[:line]
        Device::Display.print_line format(text, options), options[:line], options[:column]
        key = getc
        if key == BACK
          text = text[0..-2]
        elsif key == KEY_TIMEOUT
          return KEY_TIMEOUT
        elsif key == ENTER
          return text
        elsif key == CANCEL
          return CANCEL
        elsif key == F1 || key == DOWN || key == UP || key == ALPHA
          change_next(text, check_mask_type(text, options))
          next
        elsif text.size >= max
          next
        elsif insert_key?(key, options)
          text << key
        end
      end
    end

    def self.get_format_or_touchscreen_action(max, touch_map, options = {})
      set_default_format_option(options)
      key = text = options[:value] || ""
      time = Time.now + (options[:timeout] || 30000) / 1000
      ret = {}
      touch_clear
      Device::Display.clear options[:line]
      Device::Display.print_line format(text, options), options[:line], options[:column]
      loop do
        line_x, line_y = getxy_stream(100)
        if line_x && line_y
          ret = parse_touchscreen(touch_map, line_x, line_y)
          break(ret) if ret.include?(:touch_action)
        elsif key = getc(100)
          if key == BACK
            text = text[0..-2]
            Device::Display.clear options[:line]
            Device::Display.print_line format(text, options), options[:line], options[:column]
          elsif options[:timeout_enabled] && time < Time.now
            ret[:timeout] = Device::IO::KEY_TIMEOUT
            break(ret)
          elsif key == ENTER
            ret[:text] = text
            break(ret)
          elsif key == CANCEL
            ret[:cancel] = Device::IO::CANCEL
            break(ret)
          elsif key == F1 || key == DOWN || key == UP || key == ALPHA
            change_next(text, check_mask_type(text, options))
            next
          elsif text.size >= max
            next
          elsif insert_key?(key, options)
            text << key
            Device::Display.clear options[:line]
            Device::Display.print_line format(text, options), options[:line], options[:column]
          end
        end
      end
    end

    def self.parse_touchscreen(touch_map, line_x, line_y)
      ret = {}
      touch_map.each do |key, value|
        if value[:x].include?(line_x) && value[:y].include?(line_y)
          Device::Audio.beep(7, 60)
          ret[:touch_action] = key
        end
      end
      ret
    end

    def self.set_default_format_option(options)
      options[:mode]   ||= IO_INPUT_LETTERS
      options[:line]   ||= 2
      options[:column] ||= 0

      if options[:mask]
        options[:mask_clean] = options[:mask].chars.reject{|ch| ch.match(/[^0-9A-Za-z]/) }.join
      end
    end

    def self.check_mask_type(text, options)
      if options[:mode] == Device::IO::IO_INPUT_ALPHA
        Device::IO::MASK_ALPHA
      elsif options[:mode] == Device::IO::IO_INPUT_LETTERS
        Device::IO::MASK_LETTERS
      elsif options[:mode] == Device::IO::IO_INPUT_NUMBERS
        Device::IO::MASK_NUMBERS
      elsif options[:mode] == Device::IO::IO_INPUT_MASK
        check_mask(options[:mask_clean].to_s[text.size - 1])
      else
        Device::IO::MASK_ALPHA
      end
    end

    def self.change_next(text, mask_type = Device::IO::MASK_ALPHA)
      char = text[-1]
      if char
        range = self.keys_range[mask_type].detect { |range| range.include?(char) }
        if range
          index = range.index(char)
          new_value = range[index+1]
          if new_value
            text[-1] = new_value
          else
            text[-1] = range[0]
          end
        end
      end
      text
    end

    # Read 1 byte on keyboard, wait until be pressed
    #
    # @param timeout [Fixnum] Timeout in milliseconds to wait for key.
    # If not sent the default timeout is 30_000.
    # If nil should be blocking.
    #
    # @return [String] key read from keyboard
    def self.getc(timeout = self.timeout); super(timeout); end

    def self.format(string, options)
      options[:label].to_s +
      if options[:mode] == IO_INPUT_MONEY || options[:mode] == IO_INPUT_DECIMAL
        number_to_currency(string, options)
      elsif options[:mode] == IO_INPUT_SECRET
        "*" * string.size
      elsif options[:mode] == IO_INPUT_MASK
        string.to_mask(options[:mask])
      else
        string
      end
    end

    # => {"return" => 1, "x" => 10, "y" => 50}
    def self.getxy
      super
    end

    def self.insert_key?(key, options)
      if options[:mode] == IO_INPUT_MONEY || options[:mode] == IO_INPUT_DECIMAL || options[:mode] == IO_INPUT_NUMBERS
        NUMBERS.include?(key)
      elsif options[:mode] != IO_INPUT_NUMBERS && options[:mode] != IO_INPUT_MONEY && options[:mode] != IO_INPUT_DECIMAL
        self.keys_valid.include? key
      else
        false
      end
    end

    def self.check_mask(char)
      case char
      when "9"
        Device::IO::MASK_NUMBERS
      when "A"
        Device::IO::MASK_LETTERS
      else # "a"
        Device::IO::MASK_ALPHA
      end
    end
  end
end

