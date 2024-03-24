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

val ansii_of_color : t -> string
val is_ansi_color_disabled : unit -> bool
val from : string -> t
