module InputTest
  def loop
    str = IO.gets("Input > ")
    IO.puts str
    loop
  end
end

InputTest.loop

