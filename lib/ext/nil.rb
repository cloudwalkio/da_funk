class NilClass
  def to_big(*args)
    0
  end

  def integer?
    false
  end
end