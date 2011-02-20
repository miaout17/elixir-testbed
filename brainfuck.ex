object ListZipper
  def constructor(data)
    {'left: [], 'right: data}
  end

  def get
    @right.head
  end

  def set(val)
    [_|t] = @right
    self.set_ivar('right, [val|t])
  end

  def modify(func)
    set(func(self.get))
  end

  def to_list
    @left.reverse + @right
  end

  % Don't go out of scope, I didn't check :(
  def forward
    [h|t] = @right
    self.set_ivar('left, [h|@left]).set_ivar('right, t)
  end

  def back
    [h|t] = @left
    self.set_ivar('right, [h|@right]).set_ivar('left, t)
  end

  def start?
    @left.length == 0 % missing List.empty?
  end

  def end?
    @right.length == 0
  end
end

% test
z = ListZipper.new [2, 3, 4]
[2, 3, 4] = z.to_list
2 = z.get
3 = z.forward.get
2 = z.forward.back.get
5 = z.set(5).get
[7, 3, 4] = z.set(7).to_list
[6, 3, 4] = z.modify(-> (x) x*3).to_list
true = z.start?
false = z.forward.forward.end?

module Brainfuck
  object VM
    def constructor(code)
      code_list = code.to_list
      % IO.puts code_list.inspect
      code_zipper = ListZipper.new code_list

      % TODO: STDLIB missing lists:duplicate
      mem_list = Erlang.lists.duplicate 1000, 0
      mem_zipper = ListZipper.new mem_list
      {'code: code_zipper, 'mem: mem_zipper}
    end

    def opcode
      @code.get
    end

    def memget
      @mem.get
    end

    def memset(val)
      self.set_ivar('mem, @mem.set(val))
    end

    def modify_mem(diff)
      new_value = memget + diff
      normalized = (new_value + 256) rem 256
      memset(normalized)
    end

    def move(dir)
      self.set_ivar('mem, @mem.send(dir))
    end

    def running
      not @code.end?
    end

    def forward
      self.set_ivar('code, @code.forward)
    end

    def back
      self.set_ivar('code, @code.back)
    end

    % Lack of case..match :)
    def branch_level(dir, opcode)
      case {dir, opcode}
        match {'forward, $]} then -1
        match {'forward, $\[} then 1
        match {'back, $\[} then -1
        match {'back, $]} then 1
        else 0
      end
    end

    def branch('forward, $], 1)
      self
    end
    def branch('back, $\[, 1)
      self
    end
    def branch(dir, last_opcode, level)
      new_state = self.send(dir)
      new_state.branch(dir, new_state.opcode, level + branch_level(dir, last_opcode))
    end

    def run_op $+
      modify_mem(1)
    end

    def run_op $-
      modify_mem(-1)
    end

    def run_op $>
      move('forward)
    end

    def run_op $<
      move('back)
    end

    def run_op $\[
      if memget == 0
        branch('forward, opcode, 0)
      else
        self
      end
    end

    def run_op $]
      if memget != 0
        branch('back, opcode, 0)
      else
        self
      end
    end

    def run_op $.
      Erlang.io.format [memget]
      self
    end

    % ! is not a traditional brainfuck command, prints memory content as integer
    def run_op $!
      IO.puts memget.inspect
      self
    end

    def run_op _opc
      self
    end

    def run
      new_state = run_op(opcode).forward
      if new_state.running
        new_state.run
      end
    end
  end
end
