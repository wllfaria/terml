open Crossterml
open Style

let () = print_endline @@ make "lol" @@ fg (Color.from "\x1b[5;9") @@ styled
