open Terml

let () =
  let prev = Terminal.enable_raw_mode () in
  let channel = Events.poll () in
  let quit = ref false in
  Command.execute
    [
      Command.Terminal Terminal.EnterAlternateScreen;
      Command.Terminal Terminal.(ClearScreen All);
      Command.Cursor (Cursor.MoveTo (1, 1));
      Command.Print "use hjkl or arrow keys to move the cursor";
      Command.Cursor (Cursor.MoveTo (2, 1));
    ];
  while not !quit do
    let event = Event.sync (Event.receive channel) in
    let open Events in
    match event with
    | Key { code = Up; _ } | Key { code = Char "k"; _ } ->
        Command.execute [ Command.Cursor (Cursor.Up 1) ]
    | Key { code = Down; _ } | Key { code = Char "j"; _ } ->
        Command.execute [ Command.Cursor (Cursor.Down 1) ]
    | Key { code = Left; _ } | Key { code = Char "h"; _ } ->
        Command.execute [ Command.Cursor (Cursor.Left 1) ]
    | Key { code = Right; _ } | Key { code = Char "l"; _ } ->
        Command.execute [ Command.Cursor (Cursor.Right 1) ]
    | _ -> ()
  done;
  Terminal.disable_raw_mode prev
