object Counter
  def constructor(value)
    {'value: value}
  end

  def count_to(max)
    if @value <= max
      IO.puts @value.inspect
      self.set_ivar('value, @value+1).count_to(max)
    end
  end
end

c = Counter.new 0
c.count_to 2000

