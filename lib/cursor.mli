type cursor_style =
  | Default
  | BlinkingBlock
  | SteadyBlock
  | BlinkingUnderscore
  | SteadyUnderscore
  | BlinkingBar
  | SteadyBar

type commands = private
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

val move_to : int -> int -> commands
val next_line : unit -> commands
val previous_line : unit -> commands
val to_column : int -> commands
val to_row : int -> commands
val up : int -> commands
val right : int -> commands
val down : int -> commands
val left : int -> commands
val save_position : unit -> commands
val restore_position : unit -> commands
val hide : unit -> commands
val show : unit -> commands
val enable_blinking : unit -> commands
val disable_blinking : unit -> commands
val set_style : cursor_style -> commands
