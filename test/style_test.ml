open Terml.Style
open Terml.Color

let format_color_option color =
  match color with
  | Some Black -> "Black"
  | Some Yellow -> "Yellow"
  | Some Red -> "Red"
  | Some (Rgb (r, g, b)) -> Printf.sprintf "Rgb(%d,%d,%d)" r g b
  | _ -> "Invalid"

let format_styled styled =
  Format.sprintf "fg: %s, bg: %s, bold: %b"
    (format_color_option styled.fg)
    (format_color_option styled.bg)
    styled.bold

let test_build_styled () =
  Alcotest.(check string)
    "build styled" "fg: Red, bg: Yellow, bold: true"
    (styled () |> bold |> fg Red |> bg Yellow |> format_styled)

let test_make_styled_string () =
  Alcotest.(check string)
    "make styled string" "\x1b[38;5;9mHello World!"
    (make "Hello World!" @@ fg Red @@ styled ())

let raises_with_invalid_color () =
  Alcotest.check_raises "raises with invalid color"
    (Invalid_argument "Invalid color") (fun () ->
      ignore (styled () |> fg Red |> make "Hello World!"))

let tests =
  [
    Alcotest.test_case "build styled" `Quick test_build_styled;
    Alcotest.test_case "make styled string" `Quick test_make_styled_string;
  ]
