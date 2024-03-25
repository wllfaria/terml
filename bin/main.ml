open Terml

let () =
  let prev = Terminal.enable_raw_mode () in
  Command.execute
    [
      Command.Terminal Terminal.(EnterAlternateScreen);
      Command.Cursor Cursor.(MoveTo (0, 0));
    ];
  let should_quit = ref false in
  let channel = Events.poll () in
  while not !should_quit do
    let ev = Event.sync (Event.receive channel) in
    match ev with
    | Events.Key { code = Char "q"; _ } -> should_quit := true
    | Events.Key { code = Up; _ } ->
        Command.execute [ Command.Cursor (Cursor.Up 1) ]
    | Events.Key { code = Down; _ } ->
        Command.execute [ Command.Cursor (Cursor.Down 1) ]
    | Events.Key { code = Left; _ } ->
        Command.execute [ Command.Cursor (Cursor.Left 1) ]
    | Events.Key { code = Right; _ } ->
        Command.execute [ Command.Cursor (Cursor.Right 1) ]
    | Events.Key { modifier = Some Ctrl; _ } ->
        Command.execute [ Command.Print "ctrl" ]
    | _ -> ()
  done;
  Command.execute [ Command.Terminal Terminal.(LeaveAlternateScreen) ];
  Terminal.disable_raw_mode prev;
  exit 0
