# Copyright 2009 by Tim Becker (tim.becker@kuriostaet.de)
# MIT License, for details, see the LICENSE file accompaning
# this distribution

module ISO8583

  # This class constructs an object for handling bitmaps
  # with which ISO8583 messages typically begin.
  # Bitmaps are either 8 or 16 bytes long, an extended length
  # bitmap is indicated by the first bit being set.
  # In all likelyhood, you won't be using this class much, it's used
  # transparently by the Message class.
  class Bitmap
    include DaFunk::Helper
    # create a new Bitmap object. In case an iso message
    # is passed in, that messages bitmap will be parsed. If
    # not, this initializes and empty bitmap.
    def initialize(message = nil, hex_bitmap=false)
      @bmp        = Array.new(128, false)
      @hex_bitmap = hex_bitmap

      message ? initialize_from_message(message) : nil
    end

    def hex_bitmap?
      !!@hex_bitmap
    end

    # yield once with the number of each set field.
    def each #:yields: each bit set in the bitmap except the first bit.
      @bmp[1..-1].each_with_index {|set, i| yield i+2 if set}
    end

    # Returns whether the bit is set or not.
    def [](i)
      @bmp[i-1]
    end

    # Set the bit to the indicated value. Only `true` sets the
    # bit, any other value unsets it.
    def []=(i, value)
      if i > 128
        raise ISO8583Exception.new("Bits > 128 are not permitted.")
      elsif i < 2
        raise ISO8583Exception.new("Bits < 2 are not permitted (continutation bit is set automatically)")
      end
      @bmp[i-1] = (value == true)
    end

    # Sets bit #i
    def set(i)
      self[i] = true
    end

    # Unsets bit #i
    def unset(i)
      self[i] = false
    end

    # Generate the bytes representing this bitmap.
    def to_bytes
      if RUBY_ENGINE == 'mruby'
        # Convert binary to hex, by slicing the binary in 4 bytes chuncks
        bitmap_hex = ""
        str = ""
        self.to_s.chars.reverse.each_with_index do |ch, i|
          str << ch
          next if i == 0
          if (i+1) % 4 == 0
            bitmap_hex << str.reverse.to_i(2).to_s(16)
            str = ""
          end
        end
        unless str.empty?
          bitmap_hex << str.reverse.to_i(2).to_s(16)
        end
        bitmap_hex.reverse.upcase
      else
        [to_s].pack("B*")
      end
    end
    alias_method :to_b, :to_bytes

    def to_hex
      self.to_s.to_i(2).to_s(16).upcase
    end

    # Generate a String representation of this bitmap in the form:
    #	01001100110000011010110110010100100110011000001101011011001010
    def to_s
      #check whether any `high` bits are set
      ret           = (65..128).find {|bit| !!self[bit]}
      high, @bmp[0] = ret ? [128, true] : [64, false]

      str = ""
      1.upto(high) do|i|
        str << (self[i] ? '1' : '0')
      end

      str
    end


    private

    def convert_hex_to_binary(str)
      str.chars.reverse.inject("") do |string, ch|
        string + ch.to_i(16).to_s(2).rjust(4, "0").reverse
      end.reverse
    end

    def initialize_from_message(message)
      bmp = if hex_bitmap?
              rjust(convert_hex_to_binary(message[0..15]), 64, '0')
            else
              message.unpack("B64")[0]
            end

      if bmp[0,1] == "1"
        bmp = if hex_bitmap?
                rjust(convert_hex_to_binary(message[0..31]), 128, '0')
              else
                message.unpack("B128")[0]
              end
      end

      0.upto(bmp.length-1) do |i|
        @bmp[i] = (bmp[i,1] == "1")
      end
    end

    class << self
      # Parse the bytes in string and return the Bitmap and bytes remaining in `str`
      # after the bitmap is taken away.
      def parse(str, hex_bitmap = false)
        bmp  = Bitmap.new(str, hex_bitmap)

        rest = if bmp.hex_bitmap?
                 bmp[1] ? str[32, str.length] : str[16, str.length]
               else
                 bmp[1] ? str[16, str.length] : str[8, str.length]
               end

        [ bmp, rest ]
      end
    end

  end
end

