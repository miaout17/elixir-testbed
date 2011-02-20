% Callback function:
% Callback function has side effect :(
object Hanoi

  def constructor(callback)
    { 'callback: callback }
  end

  def run(n)
    run('source, 'dest, 'other, n)
  end

  def run(_, _, _, 0)
  end

  def run(from, to, mid, n)
    run(from, mid, to, n-1)
    @callback(from, to)
    run(from, mid, to, n-1)
  end

end

h = Hanoi.new(-> (x, y) IO.puts "#{x} => #{y}")
h.run(5)

