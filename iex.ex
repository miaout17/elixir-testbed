object EEX
  def constructor
    {'prompt: "IEX> "}
  end
  def loop
    code = IO.gets @prompt
    begin
      {result, new_binding} = Erlang.elixir.eval(code.to_list)
      IO.puts result.inspect
    rescue 'error: e
      IO.puts e.inspect
    end
    loop
  end
end

EEX.new.loop

