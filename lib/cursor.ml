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
  | MoveTo (x, y) -> Ansi.write_ansi (Printf.sprintf "%d;%dH" x y)
  | NextLine -> Ansi.write_ansi "1E"
  | PreviousLine -> Ansi.write_ansi "1F"
  | ToColumn x -> Ansi.write_ansi (Printf.sprintf "%dG" (x + 1))
  | ToRow y -> Ansi.write_ansi (Printf.sprintf "%dd" (y + 1))
  | Up n -> Ansi.write_ansi (Printf.sprintf "%dA" (n + 1))
  | Right n -> Ansi.write_ansi (Printf.sprintf "%dC" (n + 1))
  | Down n -> Ansi.write_ansi (Printf.sprintf "%dB" (n + 1))
  | Left n -> Ansi.write_ansi (Printf.sprintf "%dD" (n + 1))
  | SavePosition -> Ansi.write_ansi "7"
  | RestorePosition -> Ansi.write_ansi "8"
  | Hide -> Ansi.write_ansi "?25l"
  | Show -> Ansi.write_ansi "?25h"
  | EnableBlinking -> Ansi.write_ansi "?12h"
  | DisableBlinking -> Ansi.write_ansi "?12l"
  | SetStyle style -> (
      match style with
      | Default -> Ansi.write_ansi "0 q"
      | BlinkingBlock -> Ansi.write_ansi "1 q"
      | SteadyBlock -> Ansi.write_ansi "2 q"
      | BlinkingUnderscore -> Ansi.write_ansi "3 q"
      | SteadyUnderscore -> Ansi.write_ansi "4 q"
      | BlinkingBar -> Ansi.write_ansi "5 q"
      | SteadyBar -> Ansi.write_ansi "6 q")
