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

let color_of_ansii s =
  let sub = String.sub s 2 (String.length s - 2) in
  match String.get sub 0 with
  | '5' -> (
      let slices = String.split_on_char ';' s in
      let c = int_of_string (List.nth slices 1) in
      match c with
      | 0 -> Black
      | 1 -> DarkRed
      | 2 -> DarkGreen
      | 3 -> DarkYellow
      | 4 -> DarkBlue
      | 5 -> DarkMagenta
      | 6 -> DarkCyan
      | 7 -> Grey
      | 8 -> DarkGrey
      | 9 -> Red
      | 10 -> Green
      | 11 -> Yellow
      | 12 -> Blue
      | 13 -> Magenta
      | 14 -> Cyan
      | 15 -> White
      | _ -> raise (Invalid_color_format sub))
  | '2' ->
      let slices = String.split_on_char ';' s in
      let r = int_of_string (List.nth slices 1) in
      let g = int_of_string (List.nth slices 2) in
      let b = int_of_string (List.nth slices 3) in
      Rgb (r, g, b)
  | _ -> raise (Invalid_color_format sub)

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
  | s when String.starts_with s ~prefix:"\x1b[" -> color_of_ansii s
  | _ -> raise (Invalid_color_format s)

let ansii_of_color c =
  match c with
  | Black -> "5;0"
  | DarkRed -> "5;1"
  | DarkGreen -> "5;2"
  | DarkYellow -> "5;3"
  | DarkBlue -> "5;4"
  | DarkMagenta -> "5;5"
  | DarkCyan -> "5;6"
  | Grey -> "5;7"
  | DarkGrey -> "5;8"
  | Red -> "5;9"
  | Green -> "5;10"
  | Yellow -> "5;11"
  | Blue -> "5;12"
  | Magenta -> "5;13"
  | Cyan -> "5;14"
  | White -> "5;15"
  | Rgb (r, g, b) -> Printf.sprintf "2;%d;%d;%d" r g b

let from s = color_of_string s

let is_ansi_color_disabled () =
  match Sys.getenv_opt "NO_COLOR" with Some _ -> true | None -> false
