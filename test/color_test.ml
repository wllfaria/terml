open Crossterml.Color

let format_color color =
  match color with
  | Black -> "Black"
  | Rgb (r, g, b) -> Printf.sprintf "Rgb(%d,%d,%d)" r g b
  | _ -> "Invalid"

let test_color_of_string () =
  Alcotest.(check string)
    "from color string to color" (format_color Black)
    (format_color (from "black"))

let test_color_of_rgb () =
  Alcotest.(check string)
    "from rgb string to color"
    (format_color (Rgb (255, 0, 0)))
    (format_color (from "rgb(255, 0, 0)"))

let test_color_of_hex () =
  Alcotest.(check string)
    "from hex string to color"
    (format_color (Rgb (255, 0, 0)))
    (format_color (from "#ff0000"))

let test_color_of_ansii () =
  Alcotest.(check string)
    "from ansii string to color" (format_color Red)
    (format_color (from "\x1b[5;9"))

let raise_with_invalid_hex () =
  Alcotest.check_raises "raise with invalid hex" (Invalid_color_format "ff000")
    (fun () -> ignore (from "#ff000"))

let raise_with_invalid_rgb () =
  Alcotest.check_raises "raise with invalid rgb"
    (Invalid_color_format "rgb(255, 0, 0") (fun () ->
      ignore (from "rgb(255, 0, 0"))

let raise_with_invalid_rgb_val () =
  Alcotest.check_raises "raise with invalid rgb value range"
    (Invalid_color_range "rgb(300, 0, 0)") (fun () ->
      ignore (from "rgb(300, 0, 0)"))

let tests =
  [
    Alcotest.test_case "from color string to color" `Quick test_color_of_string;
    Alcotest.test_case "from rgb string to color" `Quick test_color_of_rgb;
    Alcotest.test_case "from hex string to color" `Quick test_color_of_hex;
    Alcotest.test_case "from ansii string to color" `Quick test_color_of_ansii;
    Alcotest.test_case "raise with invalid hex" `Quick raise_with_invalid_hex;
    Alcotest.test_case "raise with invalid rgb" `Quick raise_with_invalid_rgb;
    Alcotest.test_case "raise with invalid rgb range" `Quick
      raise_with_invalid_rgb_val;
  ]
