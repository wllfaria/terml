type window_size = { rows : int; cols : int; width : int; height : int }

type clear_type =
  | All
  | Purge
  | FromCursorDown
  | FromCursorUp
  | CurrentLine
  | UntilNewLine

(** Disables line wrapping. *)
let disable_line_wrap = Ansi.write_ansi "?7l"

(** Enables line wrapping. *)
let enable_line_wrap = Ansi.write_ansi "?7h"

(** A command that switches to the alternate screen buffer. *)
let enter_alternate_screen = Ansi.write_ansi "?1049h"

(** A command that switches back from the alternate screen buffer. *)
let leave_alternate_screen = Ansi.write_ansi "?1049l"

(** A command that scrolls the terminal up a given number of rows. *)
let scroll_up n = Printf.sprintf "%dS" n |> Ansi.write_ansi

(** A command that scrolls the terminal down a given number of rows. *)
let scroll_down n = Printf.sprintf "%dT" n |> Ansi.write_ansi

(** A command that sets the terminal buffer size (columns, rows). *)
let set_size cols rows = Printf.sprintf "8;%d;%dt" rows cols |> Ansi.write_ansi

(** A command that sets the terminal title. *)
let set_title title = Printf.sprintf "\x1b]0;%s\x07" title |> print_string

(** A command that tells the terminal to begin a synchronous update.

Terminal emulators usually iterates through each grid cell in the visible
screen and renders its current state. Applications that updates the screen
at a higher frequency can experience tearing.

When a synchronous update is enabled, the terminal will keep rendering the
previous frame until the application is ready to render the next frame.

Disabling synchronous update will cause the terminal to render the screen
as soon as possible. *)
let begin_sync_update = Ansi.write_ansi "?2026h"

(** A command that tells the terminal to end a synchronous update.

Terminal emulators usually iterates through each grid cell in the visible
screen and renders its current state. Applications that updates the screen
at a higher frequency can experience tearing.

When a synchronous update is enabled, the terminal will keep rendering the
previous frame until the application is ready to render the next frame.

Disabling synchronous update will cause the terminal to render the screen
as soon as possible. *)
let end_sync_update = Ansi.write_ansi "?2026l"

(** A command that clears the terminal screen buffer. 
[clear_type] specifies the type of clear to perform.
- [All] clears the entire screen.
- [Purge] clears the entire screen and the scrollback buffer. (history)
- [FromCursorDown] clears from the cursor to the end of the screen.
- [FromCursorUp] clears from the cursor to the beginning of the screen.
- [CurrentLine] clears the current line.
- [UntilNewLine] clears from the cursor until the new line. *)
let clear_screen clear_type =
  match clear_type with
  | All -> Ansi.write_ansi "2J"
  | Purge -> Ansi.write_ansi "3J"
  | FromCursorDown -> Ansi.write_ansi "J"
  | FromCursorUp -> Ansi.write_ansi "1J"
  | CurrentLine -> Ansi.write_ansi "2K"
  | UntilNewLine -> Ansi.write_ansi "1K"
