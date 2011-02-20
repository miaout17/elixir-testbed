Code.require "brainfuck"

% ! is not a normal brainfuck command, prints memory content as integer
% Prints 1, 2, 3...255, 0
b = Brainfuck::VM.new "+[+!]"
b.run

