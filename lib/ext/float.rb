class Float
  alias to_s_old to_s
  def to_s(*args)
    if args.first == 16
      t = self
      v = []
      loop do
        v << (t % 16).to_i
        t =  (t / 16).to_i
        break if t == 0
      end
      v.reverse.inject("") {|str, v| str << v.to_i.to_s(16)}
    else
      to_s_old(*args)
    end
  end
end

