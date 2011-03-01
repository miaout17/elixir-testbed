% Experimental code using method_missing to delegate method code to remote process

object Fridge
  def constructor(list)
    pid = Process.spawn Fridge::Proto, 'loop, [list]

    % The values returned by constructor are kept as instance variables.
    { 'pid: pid }
  end

  def method_missing(method, args)
    pid = @pid
    pid <- { Process.self, {method, args} }

    receive {pid, msg}
      msg
    after 10000
      'timedout
    end
  end

  protected

  def loop(foodlist)
    receive
    match {from, {'store, [food]}}
      from <- { Process.self, 'ok }
      loop([food|foodlist])
    match {from, {'take, [food]}}
      if foodlist.include?(food)
        from <- { Process.self, {'ok, food} }
        loop(foodlist.delete(food))
      else
        from <- { Process.self, 'not_found }
        loop(foodlist)
      end
    match {from, {'see, []}}
      from <- { Process.self, foodlist }
      loop(foodlist)
    match {from, {'destroy, []}}
      from <- { Process.self, 'ok }
    match unknown
      IO.puts "Unknown message #{unknown.inspect}"
    end
  end
end

fridge = Fridge.new(['beer,'water])
fridge.store('apples)
IO.puts "We have #{fridge.see.join(", ")} in the fridge"
fridge.take('beer)
IO.puts "We have #{fridge.see.join(", ")} in the fridge"
fridge.destroy
