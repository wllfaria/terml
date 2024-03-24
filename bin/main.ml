open Terml
open Command
open Style

let s = bold @@ italic @@ styled ~text:(Some "hello") ()

let () =
  queue
    [
      SetForegroundColor Red;
      Cursor (Cursor.MoveTo (10, 10));
      SetAttributes [ Bg Color.Green; Fg (Color.from "#ff00ff") ];
      PrintStyled s;
      Cursor (Cursor.MoveTo (20, 10));
      PrintStyled s;
    ]
