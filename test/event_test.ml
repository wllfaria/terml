open Terml.Virtual_input
open Terml.Io

let pp e =
  match e with
  | Some (Key k) -> (
      match k with
      | { code = Up; _ } -> "up"
      | { code = Down; _ } -> "down"
      | { code = Left; _ } -> "left"
      | { code = Right; _ } -> "right"
      | { code = Escape; _ } -> "escape"
      | { modifier = Some Ctrl; code = Char c } -> Printf.sprintf "<c-%s>" c
      | { code = Char _; _ } -> "unknown")
  | _ -> "Unknown"

let test_arrow_up () =
  enqueue [ "\x1b"; "["; "0"; ";"; "A" ];
  Alcotest.(check string)
    "capture arrow up" "up"
    (pp (next_event (module Terml.Virtual_input.Virtual)))

let test_arrow_down () =
  enqueue [ "\x1b"; "["; "0"; ";"; "B" ];
  Alcotest.(check string)
    "capture arrow down" "down"
    (pp (next_event (module Terml.Virtual_input.Virtual)))

let test_arrow_right () =
  enqueue [ "\x1b"; "["; "0"; ";"; "C" ];
  Alcotest.(check string)
    "capture arrow right" "right"
    (pp (next_event (module Terml.Virtual_input.Virtual)))

let test_arrow_left () =
  enqueue [ "\x1b"; "["; "0"; ";"; "D" ];
  Alcotest.(check string)
    "capture arrow left" "left"
    (pp (next_event (module Terml.Virtual_input.Virtual)))

let test_ctrl_keys () =
  enqueue
    [
      "\x01";
      "\x02";
      "\x03";
      "\x04";
      "\x05";
      "\x06";
      "\x07";
      "\x08";
      "\x09";
      "\x0a";
      "\x0b";
      "\x0c";
      "\x0d";
      "\x0e";
      "\x0f";
      "\x10";
      "\x11";
      "\x12";
      "\x13";
      "\x14";
      "\x15";
      "\x16";
      "\x17";
      "\x18";
      "\x19";
      "\x1a";
    ];
  Alcotest.(check (list string))
    "capture ctrl-c"
    [
      "<c-a>";
      "<c-b>";
      "<c-c>";
      "<c-d>";
      "<c-e>";
      "<c-f>";
      "<c-g>";
      "<c-h>";
      "<c-i>";
      "<c-j>";
      "<c-k>";
      "<c-l>";
      "<c-m>";
      "<c-n>";
      "<c-o>";
      "<c-p>";
      "<c-q>";
      "<c-r>";
      "<c-s>";
      "<c-t>";
      "<c-u>";
      "<c-v>";
      "<c-w>";
      "<c-x>";
      "<c-y>";
      "<c-z>";
    ]
    (List.map pp
       (List.init 26 (fun _ -> next_event (module Terml.Virtual_input.Virtual))))

let tests =
  [
    Alcotest.test_case "capture arrow up" `Quick test_arrow_up;
    Alcotest.test_case "capture arrow down" `Quick test_arrow_down;
    Alcotest.test_case "capture arrow right" `Quick test_arrow_right;
    Alcotest.test_case "capture arrow left" `Quick test_arrow_left;
    Alcotest.test_case "capture ctrl+keys" `Quick test_ctrl_keys;
  ]
