type cursor_style =
  | Default
  | BlinkingBlock
  | SteadyBlock
  | BlinkingUnderscore
  | SteadyUnderscore
  | BlinkingBar
  | SteadyBar

type t =
  | Hide
  | Show
  | NextLine
  | SavePosition
  | PreviousLine
  | EnableBlinking
  | RestorePosition
  | DisableBlinking
  | MoveTo of int * int
  | ToColumn of int
  | ToRow of int
  | Up of int
  | Right of int
  | Down of int
  | Left of int
  | SetStyle of cursor_style

val move_to : int -> int -> t
val next_line : unit -> t
val previous_line : unit -> t
val to_column : int -> t
val to_row : int -> t
val up : int -> t
val right : int -> t
val down : int -> t
val left : int -> t
val save_position : unit -> t
val restore_position : unit -> t
val hide : unit -> t
val show : unit -> t
val enable_blinking : unit -> t
val disable_blinking : unit -> t
val set_style : cursor_style -> t
val execute : t -> string
