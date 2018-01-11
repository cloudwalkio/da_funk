class Float
  def to_s(*args)
    case args.first
    when 16
      t = self
      v = []
      loop do
        v << (t % 16).to_i
        t =  (t / 16).to_i
        break if t == 0
      end
      v.reverse.inject("") {|str, v| str << v.to_i.to_s(16)}
    when 10, nil
      if self.to_i.is_a?(Fixnum)
        value = ("%f" % self)
      else
        t = self
        v = []
        loop do
          v << (t % 10).to_i
          t =  (t / 10).to_i
          break if t == 0
        end
        value = v.reverse.inject("") {|str, v| str << v.to_i.to_s}
      end
      remove_zero(value)
    else
      if self.to_i.is_a?(Fixnum)
        self.to_i.to_s(*args)
      else
        "%f" % self
      end
    end
  end

  def remove_zero(str)
    exclude = true
    str.reverse.chars.select do |v|
      if (v == "0" || v == ".") && exclude
        false
      else
        exclude = false
        true
      end
    end.reverse.join
  end
end

