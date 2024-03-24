type t =
  | SetForegroundColor of Color.t
  | SetBackgroundColor of Color.t
  | SetAttribute of Style.t
  | SetAttributes of Style.t list
  | Cursor of Cursor.t
  | Print of string
  | PrintStyled of Style.styled

let rec format_command cmd =
  match cmd with
  | SetForegroundColor color ->
      Ansi.escape @@ Ansi.foreground ^ ";" ^ Color.ansii_of_color color ^ "m"
  | SetBackgroundColor color ->
      Ansi.escape @@ Ansi.background ^ ";" ^ Color.ansii_of_color color ^ "m"
  | SetAttribute attr -> (
      match attr with
      | Style.Bold -> Ansi.escape (Style.to_ansii Style.Bold) ^ "m"
      | Style.Faint -> Ansi.escape (Style.to_ansii Style.Faint) ^ "m"
      | Style.Italic -> Ansi.escape (Style.to_ansii Style.Italic) ^ "m"
      | Style.Underline -> Ansi.escape (Style.to_ansii Style.Underline) ^ "m"
      | Style.Blink -> Ansi.escape (Style.to_ansii Style.Blink) ^ "m"
      | Style.Reverse -> Ansi.escape (Style.to_ansii Style.Reverse) ^ "m"
      | Style.Conceal -> Ansi.escape (Style.to_ansii Style.Conceal) ^ "m"
      | Style.Crossed -> Ansi.escape (Style.to_ansii Style.Crossed) ^ "m"
      | Style.Overline -> Ansi.escape (Style.to_ansii Style.Overline) ^ "m"
      | Style.Fg c -> format_command (SetForegroundColor c)
      | Style.Bg c -> format_command (SetBackgroundColor c))
  | SetAttributes attrs ->
      String.concat ""
      @@ List.map (fun cmd -> format_command cmd)
      @@ List.map (fun attr -> SetAttribute attr) attrs
  | Print s -> s
  | PrintStyled s -> Style.make s.text s
  | Cursor c -> Cursor.execute c

let command_queue : t list ref = ref []

let queue cmds =
  List.iter (fun cmd -> command_queue := cmd :: !command_queue) cmds

let flush () =
  List.iter
    (fun cmd -> print_string @@ format_command cmd)
    (List.rev !command_queue);
  command_queue := []

let execute cmds =
  List.iter (fun cmd -> print_string @@ format_command cmd) cmds

let clear_queue () = command_queue := []
