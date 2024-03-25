(* let should_quit = ref false *)

(* let handle_event channel = *)
(*   let event = Event.poll (Event.receive channel) in *)
(*   match event with *)
(*   | Some (Terml.Io.Key { code = Char "q"; _ }) -> *)
(*       Printf.printf "received key q, quitting: \n"; *)
(*       should_quit := true *)
(*   | Some _ -> Printf.printf "received event" *)
(*   | _ -> Unix.sleepf 0.1 *)

(* let handle_event channel = *)
(*   let event = Event.sync (Event.receive channel) in *)
(*   Printf.printf "received event\n"; *)
(*   match event with *)
(*   | Terml.Io.Key { code = Char "q"; _ } -> should_quit := true *)
(*   | _ -> Unix.sleepf 0.1 *)

let () =
  let prev = Terml.Terminal.enable_raw_mode () in
  let should_quit = ref false in
  while not !should_quit do
    let channel = Terml.Io.poll () in
    let event = Event.sync (Event.receive channel) in
    match event with
    | Terml.Io.Key { code = Char "q"; _ } -> should_quit := true
    | _ -> print_endline "received event"
  done;
  Terml.Terminal.disable_raw_mode prev

open Terml.Command
open Terml.Style
open Terml

let styled_text =
  make "Hello World"
  @@ fg (Color.from "#c1ff23")
  @@ bg (Color.from "rgb(133, 12, 32)")
  @@ bold @@ italic @@ styled ()

let () = queue [ Cursor (Cursor.MoveTo (10, 10)); Print styled_text ]
let () = queue [ Cursor (Cursor.MoveTo (20, 20)); Print styled_text ]
let () = flush ()
