open Terml

let () =
  let restore = Terminal.enable_raw_mode () in
  let greeting =
    Style.(
      styled ()
      |> bg (Color.from "#c1121f")
      |> fg (Color.from "#fdf0d5")
      |> bold
      |> make "Type anything below, use 'q' to exit: ")
  in
  Command.execute
    [
      Command.Terminal Terminal.EnterAlternateScreen;
      Command.Terminal Terminal.(ClearScreen All);
      Command.Cursor Cursor.(MoveTo (1, 1));
      Command.Print greeting;
      Command.Cursor Cursor.(MoveTo (2, 1));
    ];
  let should_quit = ref false in
  let channel = Events.poll () in
  while not !should_quit do
    let event = Event.sync (Event.receive channel) in
    match event with
    | Events.Key { code = Char "q"; _ } -> should_quit := true
    | Events.Key { code = Char c; _ } -> Command.execute [ Command.Print c ]
    | _ -> ()
  done;
  Command.execute [ Command.Terminal Terminal.LeaveAlternateScreen ];
  Terminal.disable_raw_mode restore

(* let () = *)
(*   let prev = Terminal.enable_raw_mode () in *)
(*   Command.execute *)
(*     [ *)
(*       Command.Terminal Terminal.(EnterAlternateScreen); *)
(*       Command.Cursor Cursor.(MoveTo (0, 0)); *)
(*     ]; *)
(*   let should_quit = ref false in *)
(*   let channel = Events.poll () in *)
(*   while not !should_quit do *)
(*     let ev = Event.sync (Event.receive channel) in *)
(*     match ev with *)
(*     | Events.Key { code = Char "q"; _ } -> should_quit := true *)
(*     | Events.Key { code = Up; _ } -> *)
(*         Command.execute [ Command.Cursor (Cursor.Up 1) ] *)
(*     | Events.Key { code = Down; _ } -> *)
(*         Command.execute [ Command.Cursor (Cursor.Down 1) ] *)
(*     | Events.Key { code = Left; _ } -> *)
(*         Command.execute [ Command.Cursor (Cursor.Left 1) ] *)
(*     | Events.Key { code = Right; _ } -> *)
(*         Command.execute [ Command.Cursor (Cursor.Right 1) ] *)
(*     | Events.Key { modifier = Some Ctrl; _ } -> *)
(*         Command.execute [ Command.Print "ctrl" ] *)
(*     | _ -> () *)
(*   done; *)
(*   Command.execute [ Command.Terminal Terminal.(LeaveAlternateScreen) ]; *)
(*   Terminal.disable_raw_mode prev; *)
(*   exit 0 *)
