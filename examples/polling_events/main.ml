open Terml

let () =
  let prev = Terminal.enable_raw_mode () in
  let channel = Events.poll () in
  let quit = ref false in
  Command.execute [ Command.Print "press 'q' to quit\n\n" ];
  while not !quit do
    let event = Event.sync (Event.receive channel) in
    match event with
    | Events.Key { code = Char "q"; _ } -> quit := true
    | Events.Key { code = Char c; _ } ->
        Command.execute [ Command.Print ("received key: " ^ c ^ "\n") ]
    | _ -> ()
  done;
  Terminal.disable_raw_mode prev
