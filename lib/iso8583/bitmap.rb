# encoding: utf-8
#
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

    class << self
      # Parse the bytes in string and return the Bitmap and bytes remaining in `str`
      # after the bitmap is taken away.
      def parse(str, hex_bitmap = false, bitmap_size = 64)
        bmp  = Bitmap.new(str, hex_bitmap, bitmap_size)

        rest = if bmp.hex_bitmap?
                 str[bmp.size_in_bytes_hex, str.length]
               else
                 str[bmp.size_in_bytes, str.length]
               end

        [ bmp, rest ]
      end
    end

    # bitmap_size defines the size in bits of bitmap. It has to be multiple of 8 (a byte of 8 bits)
    attr_reader :bitmap_size

    # additional_bitmap defines if the bit 1 (left to right) indicates the presence of another
    # bitmap just after the current one
    attr_reader :additional_bitmap

    attr_reader :bitmaps

    # create a new Bitmap object. In case an iso message
    # is passed in, that messages bitmap will be parsed. If
    # not, this initializes and empty bitmap.
    def initialize(message = nil, hex_bitmap=false, bitmap_size = 128, additional_bitmap = true)
      raise ISO8583Exception.new "wrong bitmap_size: #{bitmap_size}" if bitmap_size % 8 != 0

      @bitmap_size           = bitmap_size
      @bmp                   = Array.new(bitmap_size, false)
      @hex_bitmap            = hex_bitmap
      @additional_bitmap = additional_bitmap
      @bitmaps               = 1

      message ? initialize_from_message(message) : nil
    end

    def additional_bitmap?
      !!@additional_bitmap
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

    # Sets bit #i
    def set(i)
      if additional_bitmap?
        raise ISO8583Exception, "field #{i} shouldn't be set (continuation bit is set automatically)" if i % bitmap_size == 1
      end

      if i > bitmap_size
        raise ISO8583Exception, "can't set field #{i}, bitmap_size == #{bitmap_size}" unless additional_bitmap?

        quo = i / bitmap_size
        rem = i % bitmap_size
        @bitmaps = rem > 0 ? quo + 1 : quo
        new_bmp = Array.new(@bitmaps * bitmap_size, false)
        @bmp.each_with_index { |v, idx| new_bmp[idx] = v }
        0.upto(@bitmaps - 2) do |pos|
          new_bmp[pos * bitmap_size] = true
        end
        @bmp = new_bmp
      end
      self[i] = true
    end

    def size_in_bits
      bitmaps * bitmap_size
    end

    def size_in_bytes
      size_in_bits / 8
    end

    def size_in_bytes_hex
      size_in_bytes * 2
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
        str = String.new("", encoding: 'ASCII-8BIT')
        self.to_s.chars.reverse.each_with_index do |ch, i|
          str << ch
          next if i == 0
          if (i+1) % 4 == 0
            bitmap_hex << str.reverse.to_i(2).to_s(16)
            str = String.new("", encoding: 'ASCII-8BIT')
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
      self.to_s.to_i(2).to_s(16).upcase.ljust(size_in_bytes_hex, '0')
    end

    # Generate a String representation of this bitmap in the form:
    #	01001100110000011010110110010100100110011000001101011011001010
    def to_s
      str = String.new("", encoding: "ASCII-8BIT")
      1.upto(size_in_bits) do |i|
        str << (self[i] ? '1' : '0')
      end

      str
    end


    private

    # Set the bit to the indicated value. Only `true` sets the
    # bit, any other value unsets it.
    def []=(i, value)
      @bmp[i-1] = (value == true)
    end

    def convert_hex_to_binary(str)
      str.chars.reverse.inject("") do |string, ch|
        string + ch.to_i(16).to_s(2).rjust(4, "0").reverse
      end.reverse
    end

    def initialize_from_message(message)
      bmp = if hex_bitmap?
              slice_range = (bitmap_size * 2) / 8 - 1
              rjust(convert_hex_to_binary(message[0..slice_range]), bitmap_size, '0')
            else
              message.unpack("B#{bitmap_size}")[0]
            end

      if additional_bitmap?
        has_next_bitmap = bmp[0] == "1"
        while has_next_bitmap
          @bitmaps += 1
          bmp = if hex_bitmap?
                  slice_range = (bitmap_size * bitmaps * 2) / 8 - 1
                  rjust(convert_hex_to_binary(message[0..slice_range]), bitmap_size * bitmaps, '0')
                else
                  message.unpack("B#{bitmap_size * bitmaps}")[0]
                end
          has_next_bitmap = bmp[bitmap_size * (bitmaps - 1)] == "1"
        end
      end

      0.upto(bmp.length-1) do |i|
        @bmp[i] = (bmp[i,1] == "1")
      end
    end
  end
end

