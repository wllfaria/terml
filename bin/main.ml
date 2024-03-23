open Crossterml
open Style

let () =
  print_endline @@ make "lol" @@ bold @@ italic @@ underline @@ blink @@ crossed
  @@ fg (Color.Rgb (255, 0, 0))
  @@ bg (Color.from "#00ff00")
  @@ overline @@ styled
