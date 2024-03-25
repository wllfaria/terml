open Terml

let () =
  let prev = Terminal.enable_raw_mode () in
  let channel = Events.poll () in
  let quit = ref false in
  while not !quit do
    let event = Event.sync (Event.receive channel) in
    match event with
    | Events.Key { code = Char c; _ } -> Command.execute [ Command.Print c ]
    | _ -> ()
  done;
  Terminal.disable_raw_mode prev
