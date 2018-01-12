class String
  def to_mask(mask_string)
    mask_clean = mask_string.chars.reject{|ch| ch.match(/[^0-9A-Za-z]/) }.join

    str = mask_string.chars.map{|s| s.match(/[0-9A-Za-z]/) ? "%s" : s }.join
    (str % self.ljust(mask_clean.size, " ").chars).strip
  end

  def chars
    self.split("")
  end

  def integer?
    return true if self[0] == "0"
    !!Integer(self)
  rescue ArgumentError => e
    if e.message[-19..-1] == "too big for integer"
      begin
        return self.to_i.to_s.size == self.size
      rescue
        false
      end
    end
    return false
  end

  def to_i(*args)
    case args.first
    when 16
      to_big(16)
    else
      begin
        Integer(self, args.first || 10)
      rescue ArgumentError => e
        if e.message == "too big for integer"
          self.to_f(*args)
        else
          raise
        end
      end
    end
  end

  def to_big(*args)
    if args.first == 16
      self.chars.reverse.each_with_index.inject(0) do |t, v|
        t += (v[0].hex * (16 ** v[1]))
      end
    elsif args.first == 10
      self.chars.reverse.each_with_index.inject(0) do |t, v|
        t += (v[0].hex * (10 ** v[1]))
      end
    else
      to_i(*args)
    end
  end

  def snakecase
    dup.bytes.inject("") do |str, ch|
      if ch <= 90 && ! str.empty?
        str << "_"
      end
      str << ch.chr.downcase
    end
  end
end

