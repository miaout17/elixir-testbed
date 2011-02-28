object Counter
  def constructor
    {'count: 0}
  end

  def upto(n)
    if @count < n
      self.set_ivar('count, @count+1).upto(n)
    end
    % nop
  end

  def nop
    IO.puts @count.inpsect
  end
end

Counter.new.upto(10000000)
