module Iftest
  def test
    if true
      IO.puts "if true works"
    else
      IO.puts "if true fails"
    end

    if false
      IO.puts "if false fails"
    else
      IO.puts "if false works"
    end
  end
end

Iftest.test
