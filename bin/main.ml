(* let () = [ hide (); move_to 10 10; set_style BlinkingBar; show () ] |> run *)

open Crossterml

let bold s = "1;" ^ s
let orange s = "5;9" ^ s "Hello World" |> set_foreground_color Color.Yellow

(* "asda" |> bold |> *)
