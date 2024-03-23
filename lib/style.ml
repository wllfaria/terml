open Color

type styled = {
  fg_color : color option;
  bg_color : color option;
  underline_color : color option;
  bold : bool;
  underline : bool;
}

let empty =
  {
    fg_color = None;
    bg_color = None;
    underline_color = None;
    bold = false;
    underline = false;
  }

let fg_color color s = { s with fg_color = Some color }
let bg_color color s = { s with bg_color = Some color }
let underline_color color s = { s with underline_color = Some color }
let bold s = { s with bold = true }
let underline s = { s with underline = true }
