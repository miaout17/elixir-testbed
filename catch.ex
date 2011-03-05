try
  self.error {'radsyntax, "hello"}
catch 'error: {'badsyntax, str}
  IO.puts "Badsyntax: #{str}"
catch 'error: e
  IO.puts "Rescue an error with #{e} !!"
end

