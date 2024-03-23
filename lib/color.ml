type t =
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
  | Rgb of int * int * int

exception Invalid_color_format of string
exception Invalid_color_range of string

let is_ansi_color_disabled () =
  match Sys.getenv_opt "NO_COLOR" with Some _ -> true | None -> false

let to_255 str =
  match int_of_string_opt ("0x" ^ str) with
  | None -> raise (Invalid_color_format str)
  | Some c -> c

let color_of_hex s =
  let s = String.sub s 1 (String.length s - 1) in
  match String.length s with
  | 6 ->
      let r = to_255 (String.sub s 0 2) in
      let g = to_255 (String.sub s 2 2) in
      let b = to_255 (String.sub s 4 2) in
      Rgb (r, g, b)
  | _ -> raise (Invalid_color_format s)

let replace_comma s = Str.(global_replace (regexp ",") "" s)
let within_rgb_bounds colors = List.for_all (fun c -> c >= 0 && c <= 255) colors

let color_of_rgb s =
  let len = String.length s in
  let prefix = 4 in
  let sub = String.sub s prefix (len - prefix - 1) in
  match String.split_on_char ',' sub with
  | [ r; g; b ] -> (
      try
        let r = int_of_string @@ replace_comma @@ String.trim r in
        let g = int_of_string @@ replace_comma @@ String.trim g in
        let b = int_of_string @@ replace_comma @@ String.trim b in
        match within_rgb_bounds [ r; g; b ] with
        | true -> Rgb (r, g, b)
        | false -> raise (Invalid_color_range s)
      with exn -> (
        match exn with
        | Invalid_color_range _ -> raise (Invalid_color_range s)
        | _ -> raise (Invalid_color_format s)))
  | _ -> raise (Invalid_color_format s)

let color_of_string s =
  let s = String.lowercase_ascii s in
  match s with
  | "black" -> Black
  | "dark_grey" -> DarkGrey
  | "red" -> Red
  | "dark_red" -> DarkRed
  | "green" -> Green
  | "dark_green" -> DarkGreen
  | "yellow" -> Yellow
  | "dark_yellow" -> DarkYellow
  | "blue" -> Blue
  | "dark_blue" -> DarkBlue
  | "magenta" -> Magenta
  | "dark_magenta" -> DarkMagenta
  | "cyan" -> Cyan
  | "dark_cyan" -> DarkCyan
  | "white" -> White
  | "grey" -> Grey
  | s when String.get s 0 = '#' -> color_of_hex s
  | s when String.starts_with s ~prefix:"rgb(" -> color_of_rgb s
  | _ -> raise (Invalid_color_format s)

let from s = color_of_string s

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

let ansii_of_color c =
  match c with
  | Black -> "0"
  | DarkRed -> "1"
  | DarkGreen -> "2"
  | DarkYellow -> "3"
  | DarkBlue -> "4"
  | DarkMagenta -> "5"
  | DarkCyan -> "6"
  | Grey -> "7"
  | DarkGrey -> "8"
  | Red -> "9"
  | Green -> "10"
  | Yellow -> "11"
  | Blue -> "12"
  | Magenta -> "13"
  | Cyan -> "14"
  | White -> "15"
  | Rgb (r, g, b) -> Printf.sprintf "2;%d;%d;%d" r g b
