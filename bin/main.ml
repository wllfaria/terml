open Terml

let () =
  let prev = Terminal.enable_raw_mode () in
  let should_quit = ref false in
  let channel = Io.poll () in
  while not !should_quit do
    let ev = Event.sync (Event.receive channel) in
    match ev with
    | Io.Key { modifier = Some Ctrl; _ } -> print_endline "Ctrl"
    | Io.Key { code = Char "q"; _ } -> should_quit := true
    | Io.Key { code = Up; _ } -> print_endline "up"
    | Io.Key { code = Down; _ } -> print_endline "down"
    | Io.Key { code = Left; _ } -> print_endline "left"
    | Io.Key { code = Right; _ } -> print_endline "right"
    | Io.Key { code = Char c; _ } -> print_endline c
    | Io.Key { code = Escape; _ } -> print_endline "escape"
  done;
  Terml.Terminal.disable_raw_mode prev;
  exit 0
