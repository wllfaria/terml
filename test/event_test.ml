open Terml.Virtual_input.Virtual
open Terml.Event

let pp e =
  match e with
  | Key k -> (
      match k with
      | { code = Up; _ } -> "Up"
      | { code = Down; _ } -> "Down"
      | { code = Left; _ } -> "Left"
      | { code = Right; _ } -> "Right"
      | { code = Escape; _ } -> "Escape"
      | { code = Char _; _ } -> "Unknown")

let test_arrow_up () =
  enqueue [ "\x1b"; "["; "0"; ";"; "A" ];
  Alcotest.(check string)
    "capture arrow up" "Up"
    (pp (poll (module Terml.Virtual_input.Virtual)))

let test_arrow_down () =
  enqueue [ "\x1b"; "["; "0"; ";"; "B" ];
  Alcotest.(check string)
    "capture arrow down" "Down"
    (pp (poll (module Terml.Virtual_input.Virtual)))

let test_arrow_right () =
  enqueue [ "\x1b"; "["; "0"; ";"; "C" ];
  Alcotest.(check string)
    "capture arrow right" "Right"
    (pp (poll (module Terml.Virtual_input.Virtual)))

let test_arrow_left () =
  enqueue [ "\x1b"; "["; "0"; ";"; "D" ];
  Alcotest.(check string)
    "capture arrow left" "Left"
    (pp (poll (module Terml.Virtual_input.Virtual)))

let tests =
  [
    Alcotest.test_case "capture arrow up" `Quick test_arrow_up;
    Alcotest.test_case "capture arrow down" `Quick test_arrow_down;
    Alcotest.test_case "capture arrow right" `Quick test_arrow_right;
    Alcotest.test_case "capture arrow left" `Quick test_arrow_left;
  ]
