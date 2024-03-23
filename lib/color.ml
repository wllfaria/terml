type color =
  | Black
  | DarkGrey
  | Red
  | DarkRed
  | Green
  | DarkGreen
  | Yellow
  | DarkYellow
  | Blue
  | DarkBlue
  | Magenta
  | DarkMagenta
  | Cyan
  | DarkCyan
  | White
  | Grey
  | Reset
  | Rgb of int * int * int
  | Hex of string

let is_ansi_color_disabled () =
  match Sys.getenv_opt "NO_COLOR" with Some _ -> true | None -> false

let color_of_hex s =
  let s = String.sub s 1 (String.length s - 1) in
  match String.length s with 6 -> Ok (Hex s) | _ -> Error "Invalid hex string"

let replace_comma s = Str.(global_replace (regexp ",") "" s)
let within_rgb_bounds colors = List.for_all (fun c -> c >= 0 && c <= 255) colors

let color_of_rgb s =
  let len = String.length s in
  let prefix = 4 in
  let s = String.sub s prefix (len - prefix - 1) in
  match String.split_on_char ',' s with
  | [ r; g; b ] -> (
      try
        let r = int_of_string @@ replace_comma @@ String.trim r in
        let g = int_of_string @@ replace_comma @@ String.trim g in
        let b = int_of_string @@ replace_comma @@ String.trim b in
        match within_rgb_bounds [ r; g; b ] with
        | true -> Ok (Rgb (r, g, b))
        | false -> Error "Invalid rgb color"
      with _ -> Error "Invalid rgb color")
  | _ -> Error "Invalid rgb color"

let color_of_string s =
  let s = String.lowercase_ascii s in
  match s with
  | "black" -> Ok Black
  | "dark_grey" -> Ok DarkGrey
  | "red" -> Ok Red
  | "dark_red" -> Ok DarkRed
  | "green" -> Ok Green
  | "dark_green" -> Ok DarkGreen
  | "yellow" -> Ok Yellow
  | "dark_yellow" -> Ok DarkYellow
  | "blue" -> Ok Blue
  | "dark_blue" -> Ok DarkBlue
  | "magenta" -> Ok Magenta
  | "dark_magenta" -> Ok DarkMagenta
  | "cyan" -> Ok Cyan
  | "dark_cyan" -> Ok DarkCyan
  | "white" -> Ok White
  | "grey" -> Ok Grey
  | "reset" -> Ok Reset
  | s when String.get s 0 = '#' -> color_of_hex s
  | s when String.starts_with s ~prefix:"rgb(" -> color_of_rgb s
  | _ -> Error "Invalid color"

let string_of_color c =
  match c with
  | Black -> "black"
  | DarkGrey -> "dark_grey"
  | Red -> "red"
  | DarkRed -> "dark_red"
  | Green -> "green"
  | DarkGreen -> "dark_green"
  | Yellow -> "yellow"
  | DarkYellow -> "dark_yellow"
  | Blue -> "blue"
  | DarkBlue -> "dark_blue"
  | Magenta -> "magenta"
  | DarkMagenta -> "dark_magenta"
  | Cyan -> "cyan"
  | DarkCyan -> "dark_cyan"
  | White -> "white"
  | Grey -> "grey"
  | Reset -> "reset"
  | Rgb (r, g, b) -> Printf.sprintf "rgb(%d, %d, %d)" r g b
  | Hex hex -> Printf.sprintf "%s" hex

let color_of_ansii s =
  match String.get s 0 with
  | '5' -> (
      let slices = String.split_on_char ';' s in
      let c = int_of_string (List.nth slices 1) in
      match c with
      | 0 -> Ok Black
      | 1 -> Ok DarkRed
      | 2 -> Ok DarkGreen
      | 3 -> Ok DarkYellow
      | 4 -> Ok DarkBlue
      | 5 -> Ok DarkMagenta
      | 6 -> Ok DarkCyan
      | 7 -> Ok Grey
      | 8 -> Ok DarkGrey
      | 9 -> Ok Red
      | 10 -> Ok Green
      | 11 -> Ok Yellow
      | 12 -> Ok Blue
      | 13 -> Ok Magenta
      | 14 -> Ok Cyan
      | 15 -> Ok White
      | _ -> Error "Invalid ansii sequence")
  | '2' ->
      let slices = String.split_on_char ';' s in
      let r = int_of_string (List.nth slices 1) in
      let g = int_of_string (List.nth slices 2) in
      let b = int_of_string (List.nth slices 3) in
      Ok (Rgb (r, g, b))
  | _ -> Error "Invalid ansii sequence"
