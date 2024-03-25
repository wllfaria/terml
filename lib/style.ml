type t =
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

type styled = {
  text : string;
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

let styled ?(text = None) () =
  {
    text = (match text with Some s -> s | None -> "");
    fg = None;
    bg = None;
    underline_color = None;
    bold = false;
    faint = false;
    italic = false;
    underline = false;
    blink = false;
    reverse = false;
    conceal = false;
    crossed = false;
    overline = false;
  }

let make_sequence s =
  [
    (if s.bold then [ Bold ] else []);
    (if s.faint then [ Faint ] else []);
    (if s.italic then [ Italic ] else []);
    (if s.underline then [ Underline ] else []);
    (if s.blink then [ Blink ] else []);
    (if s.reverse then [ Reverse ] else []);
    (if s.conceal then [ Conceal ] else []);
    (if s.crossed then [ Crossed ] else []);
    (if s.overline then [ Overline ] else []);
    (match s.fg with Some c -> [ Fg c ] | None -> []);
    (match s.bg with Some c -> [ Bg c ] | None -> []);
  ]
  |> List.flatten

let fg color s = { s with fg = Some color }
let bg color s = { s with bg = Some color }
let bold s = { s with bold = true }
let faint s = { s with faint = true }
let italic s = { s with italic = true }
let underline s = { s with underline = true }
let blink s = { s with blink = true }
let reverse s = { s with reverse = true }
let conceal s = { s with conceal = true }
let crossed s = { s with crossed = true }
let overline s = { s with overline = true }
let underline_color color s = { s with underline_color = Some color }

let to_ansii s =
  match s with
  | Bold -> Ansi.bold
  | Faint -> Ansi.faint
  | Italic -> Ansi.italic
  | Underline -> Ansi.underline
  | Blink -> Ansi.blink
  | Reverse -> Ansi.reverse
  | Conceal -> Ansi.conceal
  | Crossed -> Ansi.strike
  | Overline -> Ansi.overline
  | Fg c -> Ansi.foreground ^ ";" ^ Color.ansii_of_color c
  | Bg c -> Ansi.background ^ ";" ^ Color.ansii_of_color c

let make text s =
  let seq = make_sequence s in
  let fmt = List.map to_ansii seq |> String.concat ";" in
  Ansi.escape fmt ^ "m" ^ text ^ Ansi.escape Ansi.reset ^ "m"
