open Crossterml.Style
open Crossterml.Color

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

let build_string_with_style () =
  Alcotest.(check string)
    "from string to styled" "fg: Red, bg: Yellow, bold: true"
    (styled |> bold |> fg Red |> bg Yellow |> format_styled)

let tests =
  [
    Alcotest.test_case "build_string_with_style" `Quick build_string_with_style;
  ]
