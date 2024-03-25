open Terml

let () =
  Command.execute [ Command.Terminal Terminal.EnterAlternateScreen ];
  let on_alternate =
    Style.(fg (Color.from "#4cc9f0") @@ bg Color.Black @@ styled ())
  in
  let on_normal =
    Style.(fg (Color.from "#a7c957") @@ bg Color.Black @@ styled ())
  in
  let timer = ref 3 in
  let rec loop () =
    if !timer <= 0 then
      Command.execute
        [
          Command.Terminal Terminal.LeaveAlternateScreen;
          Command.Print (Style.make "You are in the main screen" on_normal);
        ]
    else
      Command.execute
        [
          Command.Terminal Terminal.(ClearScreen All);
          Command.Cursor Cursor.(MoveTo (1, 1));
          Command.Print
            (Style.make
               (Printf.sprintf "You'll leave the alternate screen in %d seconds"
                  !timer)
               on_alternate);
        ];

    Unix.sleep 1;
    decr timer;
    loop ()
  in
  loop ()
