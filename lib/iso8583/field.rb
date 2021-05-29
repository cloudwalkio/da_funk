module ISO8583

  class Field
    # may either be some other Field in which the length is encoded or a Fixnum for
    # fixed length fields. Length should always be the length of the *encoded* value.
    # A 6 digit BCD field will require a length 3, as will a 5 digit BCD field.
    # The subclass BCDField handles this to keep things consistant.
    attr_accessor :length
    attr_accessor :codec
    attr_accessor :padding
    attr_accessor :max

    attr_writer   :name
    attr_accessor :bmp

    def name
      "BMP #{bmp}: #{@name}"
    end

    def parse(raw)
      len, raw = case length
                 when Integer
                   [length, raw]
                 when Field
                   length.parse(raw)
                 else
                   raise ISO8583Exception.new("Cannot determine the length of '#{name}' field")
                 end

      raw_value = raw[0,len]

      # make sure we have enough data ...
      if raw_value.length != len
        mes = "Field (#{name}) has incorrect length! field: #{raw_value} len/expected: #{raw_value.length}/#{len}"
        raise ISO8583ParseException.new(mes)
      end

      rest = raw[len, raw.length]
      begin
        real_value = codec.decode(raw_value)
      rescue => e
        ContextLog.exception e, e.backtrace if Object.const_defined?(:ContextLog)
        raise ISO8583ParseException.new(e.message+" (#{name})")
      end

      [ real_value, rest ]
    end


    # Encoding needs to consider length representation, the actual encoding (such as charset or BCD)
    # and padding.
    # The order may be important! This impl calls codec.encode and then pads, in case you need the other
    # special treatment, you may need to override this method alltogether.
    # In other cases, the padding has to be implemented by the codec, such as BCD with an odd number of nibbles.
    def encode(value)
      begin
        encoded_value = codec.encode(value)
      rescue ISO8583Exception => e
        ContextLog.exception(e, e.backtrace, "#{e.message} (#{name})") if Object.const_defined?(:ContextLog)
        raise ISO8583Exception.new(e.message+" (#{name})")
      end

      if padding
        if padding.arity == 1
          encoded_value = padding.call(encoded_value)
        elsif padding.arity == 2
          encoded_value = padding.call(encoded_value, length)
        end
      end

      len_str = case length
                when Integer
                  raise ISO8583Exception.new("Too long: #{value} (#{name})! length=#{length}")  if encoded_value.length > length
                  raise ISO8583Exception.new("Too short: #{value} (#{name})! length=#{length}") if encoded_value.length < length
                  String.new("", encoding: 'ASCII-8BIT')
                when Field
                  raise ISO8583Exception.new("Max lenth exceeded: #{value}, max: #{max}") if max && encoded_value.length > max
                  length.encode(encoded_value.length)
                else
                  raise ISO8583Exception.new("Invalid length (#{length}) for '#{name}' field")
                end

      len_str + encoded_value
    end
  end

  class BCDField < Field
    attr_accessor :data_length
    attr_accessor :byte_length
    # This corrects the length for BCD fields, as their encoded length is half (+ parity) of the
    # content length. E.g. 123 (length = 3) encodes to "\x01\x23" (length 2)
    def length
      if @length.respond_to?(:odd?)
        @data_length = @length
        if @data_length.odd?
          @byte_length = (@data_length + 1) / 2
        else
          @byte_length = @data_length / 2
        end
        return @byte_length
      end
      @length
    end

    def encode(value)
      begin
        encoded_value = codec.encode(value)
        @data_length = value.size
        @byte_length = encoded_value.bytes.size
      rescue ISO8583Exception => e
        ContextLog.exception(e, e.backtrace, "#{e.message} (#{name})") if Object.const_defined?(:ContextLog)
        raise ISO8583Exception.new(e.message+" (#{name})")
      end

      if padding
        if padding.arity == 1
          encoded_value = padding.call(encoded_value)
        elsif padding.arity == 2
          encoded_value = padding.call(encoded_value, length)
        end
      end

      len_str = case length
                when Integer
                  raise ISO8583Exception.new("Too long: #{value} (#{name})! length=#{length}")  if encoded_value.length > length
                  raise ISO8583Exception.new("Too short: #{value} (#{name})! length=#{length}") if encoded_value.length < length
                  String.new("", encoding: 'ASCII-8BIT')
                when Field
                  raise ISO8583Exception.new("Max length exceeded: #{value}, max: #{max}") if max && @byte_length > max
                  length.encode(@data_length)
                else
                  raise ISO8583Exception.new("Invalid length (#{length}) for '#{name}' field")
                end

      len_str + encoded_value

    end
  end

end

