module Hanoi

  def run(n)
    run('source, 'dest, 'other, n)
  end

  def run(_, _, _, 0)
    []
  end

  def run(from, to, mid, n)
    run(from, mid, to, n-1) + [{from, to}] + run(from, mid, to, n-1)
  end

end

result = Hanoi.run(5)
result.each -> ({x, y}) IO.puts("#{x} => #{y}")

