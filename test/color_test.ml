open Crossterml

let string_of_rgb () =
  Alcotest.(check string)
    "from rgb to string" "rgb(255, 0, 0)"
    (Color.string_of_color (Color.Rgb (255, 0, 0)))

let string_of_color () =
  Alcotest.(check string)
    "from color to string" "black"
    (Color.string_of_color Color.Black)

let string_of_hex () =
  Alcotest.(check string)
    "from hex to string" "#ff0000"
    (Color.string_of_color (Color.Hex "#ff0000"))

let format_color color =
  match color with
  | Color.Black -> "Black"
  | Color.Rgb (r, g, b) -> Printf.sprintf "Rgb(%d,%d,%d)" r g b
  | Color.Hex hex -> Printf.sprintf "Hex(%s)" hex
  | _ -> "Invalid"

let color_testable =
  let open Alcotest in
  let pp fmt color =
    let print_color = format_color color in
    Format.fprintf fmt "%s" print_color
  in
  testable pp ( = )

let color_of_string () =
  Alcotest.(check (result color_testable string))
    "from color string to color" (Ok Color.Black)
    (Color.color_of_string "black")

let color_of_hex_string () =
  Alcotest.(check (result color_testable string))
    "from hex string to color" (Ok (Color.Hex "ff0000"))
    (Color.color_of_string "#ff0000")

let color_of_rgb_string () =
  Alcotest.(check (result color_testable string))
    "from rgb string to color"
    (Ok (Color.Rgb (255, 0, 0)))
    (Color.color_of_string "rgb(255, 0, 0)")

let color_of_reset_string () =
  Alcotest.(check (result color_testable string))
    "from reset string to color" (Ok Color.Reset)
    (Color.color_of_string "reset")

let error_of_invalid () =
  Alcotest.(check (result color_testable string))
    "from invalid string to error" (Error "Invalid color")
    (Color.color_of_string "invalid")

let invalid_rgb_error () =
  Alcotest.(check (result color_testable string))
    "from invalid rgb string to error" (Error "Invalid rgb color")
    (Color.color_of_string "rgb(1234, 1, 1)")

let tests =
  [
    Alcotest.test_case "From rgb to string" `Quick string_of_rgb;
    Alcotest.test_case "From color to string" `Quick string_of_color;
    Alcotest.test_case "From hex to string" `Quick string_of_hex;
    Alcotest.test_case "from color string to color" `Quick color_of_string;
    Alcotest.test_case "from rgb string to color" `Quick color_of_rgb_string;
    Alcotest.test_case "from hex string to color" `Quick color_of_hex_string;
    Alcotest.test_case "from invalid string to error" `Quick error_of_invalid;
    Alcotest.test_case "from invalid rgb to error" `Quick invalid_rgb_error;
    Alcotest.test_case "from reset string to color" `Quick color_of_reset_string;
  ]
