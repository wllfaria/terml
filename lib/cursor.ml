let write_ansi fmt = Printf.printf "\x1b[%s" fmt

type cursor_style =
  | Default
  | BlinkingBlock
  | SteadyBlock
  | BlinkingUnderscore
  | SteadyUnderscore
  | BlinkingBar
  | SteadyBar

type commands =
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

let move command =
  match command with
  | MoveTo (x, y) -> write_ansi (Printf.sprintf "%d;%dH" x y)
  | NextLine -> write_ansi "1E"
  | PreviousLine -> write_ansi "1F"
  | ToColumn x -> write_ansi (Printf.sprintf "%dG" (x + 1))
  | ToRow y -> write_ansi (Printf.sprintf "%dd" (y + 1))
  | Up n -> write_ansi (Printf.sprintf "%dA" (n + 1))
  | Right n -> write_ansi (Printf.sprintf "%dC" (n + 1))
  | Down n -> write_ansi (Printf.sprintf "%dB" (n + 1))
  | Left n -> write_ansi (Printf.sprintf "%dD" (n + 1))
  | SavePosition -> write_ansi "7"
  | RestorePosition -> write_ansi "8"
  | Hide -> write_ansi "?25l"
  | Show -> write_ansi "?25h"
  | EnableBlinking -> write_ansi "?12h"
  | DisableBlinking -> write_ansi "?12l"
  | SetStyle style -> (
      match style with
      | Default -> write_ansi "0 q"
      | BlinkingBlock -> write_ansi "1 q"
      | SteadyBlock -> write_ansi "2 q"
      | BlinkingUnderscore -> write_ansi "3 q"
      | SteadyUnderscore -> write_ansi "4 q"
      | BlinkingBar -> write_ansi "5 q"
      | SteadyBar -> write_ansi "6 q")
