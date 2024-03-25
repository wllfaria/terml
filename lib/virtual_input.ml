let queue = Queue.create ()
let enqueue input = List.iter (fun i -> Queue.push i queue) input

module Virtual : Input_source.t = struct
  let read () = if Queue.is_empty queue then `End else `Read (Queue.take queue)
end
