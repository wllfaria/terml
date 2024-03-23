type t = private
  | Bold
  | Faint
  | Italic
  | Underline
  | Blink
  | Reverse
  | Conceal
  | Crossed
  | Overline
  | Fg of Color.t
  | Bg of Color.t

type styled = private {
  fg : Color.t option;
  bg : Color.t option;
  underline_color : Color.t option;
  bold : bool;
  faint : bool;
  italic : bool;
  underline : bool;
  blink : bool;
  reverse : bool;
  conceal : bool;
  crossed : bool;
  overline : bool;
}

val styled : styled
val make_sequence : styled -> t list
val fg : Color.t -> styled -> styled
val bg : Color.t -> styled -> styled
val bold : styled -> styled
val faint : styled -> styled
val italic : styled -> styled
val underline : styled -> styled
val blink : styled -> styled
val reverse : styled -> styled
val conceal : styled -> styled
val crossed : styled -> styled
val overline : styled -> styled
val underline_color : Color.t -> styled -> styled
val make : string -> styled -> string
