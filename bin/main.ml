open Crossterml

let () =
  let counter = ref 0 in
  while !counter < 100_000_000 do
    let () = Cursor.move (Cursor.MoveTo (10, 13)) in
    incr counter
  done
