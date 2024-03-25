open Terml

let () =
  let prev = Terminal.enable_raw_mode () in
  let should_quit = ref false in
  let channel = Events.poll () in
  while not !should_quit do
    let ev = Event.sync (Event.receive channel) in
    match ev with
    | Events.Key { modifier = Some Ctrl; _ } -> print_endline "Ctrl"
    | Events.Key { code = Char "q"; _ } -> should_quit := true
    | Events.Key { code = Up; _ } -> print_endline "up"
    | Events.Key { code = Down; _ } -> print_endline "down"
    | Events.Key { code = Left; _ } -> print_endline "left"
    | Events.Key { code = Right; _ } -> print_endline "right"
    | Events.Key { code = Char c; _ } -> print_endline c
    | Events.Key { code = Escape; _ } -> print_endline "escape"
  done;
  Terml.Terminal.disable_raw_mode prev;
  exit 0
