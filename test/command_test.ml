open Terml
open Terml.Command

let print_queue queue = List.map (fun cmd -> format_command cmd) !queue

let test_build_command_queue () =
  clear_queue ();
  queue
    [
      SetForegroundColor (Color.from "#cecece");
      SetBackgroundColor (Color.from "#242424");
      Cursor (Cursor.MoveTo (3, 13));
      SetAttributes [ Style.Bold ];
      Print "Hello, World!";
    ];
  Alcotest.(check (list string))
    "build command queue"
    [
      "Hello, World!";
      "\027[1m";
      "\027[3;13H";
      "\027[48;2;36;36;36m";
      "\027[38;2;206;206;206m";
    ]
    (print_queue command_queue)

let tests =
  [ Alcotest.test_case "build command queue" `Quick test_build_command_queue ]
