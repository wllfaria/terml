type t =
  | SetForegroundColor of Color.t
  | SetBackgroundColor of Color.t
  | SetAttribute of Style.t
  | SetAttributes of Style.t list
  | Cursor of Cursor.t
  | Terminal of Terminal.t
  | Print of string
  | PrintStyled of Style.styled

val command_queue : t list ref
val queue : t list -> unit
val flush : unit -> unit
val execute : t list -> unit
val clear_queue : unit -> unit
val format_command : t -> string
