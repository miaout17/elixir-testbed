str = "你好嗎"
IO.puts "#{str} .length is #{str.length}"
IO.puts "#{str} .to_list.length is #{str.to_list.length}"

% Erlang.length(Erlang.unicode.characters_to_list(bin, 'utf8))
