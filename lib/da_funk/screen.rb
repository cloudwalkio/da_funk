
class Screen
  SCREEN_X_SIZE = 21
  SCREEN_Y_SIZE = 7

  attr_accessor :x, :y, :max_x, :max_y

  def self.setup(max_x = SCREEN_X_SIZE, max_y = SCREEN_Y_SIZE)
    $stdout.close
    Object.const_set(:STDOUT, self.new(max_x, max_y))
    $stdout = Object::STDOUT
  end

  def initialize(max_x = SCREEN_X_SIZE, max_y = SCREEN_Y_SIZE)
    @max_x = max_x
    @max_y = max_y
    self.fresh
  end

  def fresh(value_y = 0, value_x = 0)
    @x = value_x || 0
    @y = value_y || 0
  end

  def jump_line(value = 1)
    @y += value
    @x = 0
    @y = 0 if (@y > (@max_y-1))
  end

  def print(*args)
    if n_strings?(args)
      loop_n_strings(*args)
    else
      loop_split_strings(*args)
    end
    nil
  end

  def printf(*args)
    print(sprintf(*args))
  end

  def puts(*args)
    if n_strings?(args)
      args = args.map {|str| "#{str}\n" }
    else
      args[0] = "#{args.first}\n"
    end
    print(*args)
  end

  def add(string, line, column)
    string.split("\n", -1).each_with_index do |str, i|
      self.y = i + line
      self.x = column
      Device::Display.print(str, self.y, self.x)
      self.x = column + str.size
    end
  end

  private
  def loop_split_strings(*args)
    str, value_y, value_x = *args
    @y = value_y if value_y
    @x = value_x if value_x

    str.to_s.lines.each_with_index do |string, index|
      buf = string.chomp
      if (@x + buf.size) < @max_x
        Device::Display.print(buf, @y, @x)
        @x += buf.size
        jump_line if string[-1] == "\n"
      else
        space = @max_x - @x
        Device::Display.print("#{string[0..(space - 1)]}", @y.to_i, @x.to_i)
        jump_line
        loop_split_strings("#{string[space..-1]}")
      end
    end
  end

  def loop_n_strings(*args)
    args.each { |str| self.print(str) }
  end

  # various arguments as string, example:
  #   puts "12", "23", "34"
  #   # or
  #   puts "12", 1, 2
  def n_strings?(args)
    if args[0].is_a?(String) && args[1].is_a?(String)
      true
    else
      false
    end
  end
end

