let stdin_fd = Unix.descr_of_in_channel stdin

type clear_type =
  | All
  | Purge
  | FromCursorDown
  | FromCursorUp
  | CurrentLine
  | UntilNewLine

type t =
  | DisableLineWrap
  | EnableLineWrap
  | EnterAlternateScreen
  | LeaveAlternateScreen
  | ScrollUp of int
  | ScrollDown of int
  | SetSize of int * int
  | SetTitle of string
  | BeginSyncUpdate
  | EndSyncUpdate
  | ClearScreen of clear_type

type window_size = { rows : int; cols : int; width : int; height : int }

(** Disables line wrapping. *)
let disable_line_wrap = Ansi.escape "?7l"

(** Enables line wrapping. *)
let enable_line_wrap = Ansi.escape "?7h"

(** A command that switches to the alternate screen buffer. *)
let enter_alternate_screen = Ansi.escape "?1049h"

(** A command that switches back from the alternate screen buffer. *)
let leave_alternate_screen = Ansi.escape "?1049l"

(** A command that scrolls the terminal up a given number of rows. *)
let scroll_up n = Ansi.escape @@ Printf.sprintf "%dS" n

(** A command that scrolls the terminal down a given number of rows. *)
let scroll_down n = Ansi.escape @@ Printf.sprintf "%dT" n

(** A command that sets the terminal buffer size (columns, rows). *)
let set_size cols rows = Ansi.escape @@ Printf.sprintf "8;%d;%dt" rows cols

(** A command that sets the terminal title. *)
let set_title title = Printf.sprintf "\x1b]0;%s\x07" title

(** A command that tells the terminal to begin a synchronous update.

Terminal emulators usually iterates through each grid cell in the visible
screen and renders its current state. Applications that updates the screen
at a higher frequency can experience tearing.

When a synchronous update is enabled, the terminal will keep rendering the
previous frame until the application is ready to render the next frame.

Disabling synchronous update will cause the terminal to render the screen
as soon as possible. *)
let begin_sync_update = Ansi.escape "?2026h"

(** A command that tells the terminal to end a synchronous update.

Terminal emulators usually iterates through each grid cell in the visible
screen and renders its current state. Applications that updates the screen
at a higher frequency can experience tearing.

When a synchronous update is enabled, the terminal will keep rendering the
previous frame until the application is ready to render the next frame.

Disabling synchronous update will cause the terminal to render the screen
as soon as possible. *)
let end_sync_update = Ansi.escape "?2026l"

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
  | All -> Ansi.escape "2J"
  | Purge -> Ansi.escape "3J"
  | FromCursorDown -> Ansi.escape "J"
  | FromCursorUp -> Ansi.escape "1J"
  | CurrentLine -> Ansi.escape "2K"
  | UntilNewLine -> Ansi.escape "1K"

(** Enable raw mode for the current terminal.
Returns the previous terminal settings so that they can be restored later. *)
let enable_raw_mode () =
  let termios = Unix.tcgetattr stdin_fd in
  let new_termios =
    Unix.
      { termios with c_icanon = false; c_echo = false; c_vmin = 0; c_vtime = 1 }
  in
  Unix.tcsetattr stdin_fd Unix.TCSAFLUSH new_termios;
  termios

(** Disables raw mode for the current terminal.
[termios] is the terminal settings that were previously saved by [enable_raw_mode]. 
*)
let disable_raw_mode termios = Unix.tcsetattr stdin_fd Unix.TCSAFLUSH termios

let execute command =
  match command with
  | DisableLineWrap -> disable_line_wrap
  | EnableLineWrap -> enable_line_wrap
  | EnterAlternateScreen -> enter_alternate_screen
  | LeaveAlternateScreen -> leave_alternate_screen
  | ScrollUp n -> scroll_up n
  | ScrollDown n -> scroll_down n
  | SetSize (cols, rows) -> set_size cols rows
  | SetTitle title -> set_title title
  | BeginSyncUpdate -> begin_sync_update
  | EndSyncUpdate -> end_sync_update
  | ClearScreen clear_type -> clear_screen clear_type
