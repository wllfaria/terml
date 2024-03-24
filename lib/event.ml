type key_code = Escape | Char of string | Up | Down | Left | Right
type key_modifiers = Shift | Ctrl | Alt | Super | Hyper | Meta | None
type key_event = { code : key_code; modifiers : key_modifiers }
type t = Key of key_event

let handle_csi_key key =
  match key with
  | "A" -> Key { code = Up; modifiers = None }
  | "B" -> Key { code = Down; modifiers = None }
  | "C" -> Key { code = Right; modifiers = None }
  | "D" -> Key { code = Left; modifiers = None }
  | _ -> Key { code = Escape; modifiers = None }

let handle_possible_arrow (module I : Input_source.t) =
  (* we read another key, as it will always be a ; *)
  ignore @@ I.read ();
  match I.read () with
  | `Read "A" -> Key { code = Up; modifiers = None }
  | `Read "B" -> Key { code = Down; modifiers = None }
  | `Read "C" -> Key { code = Right; modifiers = None }
  | `Read "D" -> Key { code = Left; modifiers = None }
  | _ -> Key { code = Escape; modifiers = None }

let handle_csi (module I : Input_source.t) =
  match I.read () with
  | `Read "[" -> (
      (* its a ansii sequence, so we read one more *)
      match I.read () with
      | `Read "0" -> handle_possible_arrow (module I)
      | `Read key -> handle_csi_key key
      | _ -> Key { code = Escape; modifiers = None })
  | _ -> Key { code = Escape; modifiers = None }

let rec poll (module I : Input_source.t) =
  match I.read () with
  | `Read key -> (
      match key with
      | "\x1b" -> handle_csi (module I)
      | c -> Key { code = Char c; modifiers = None })
  | _ -> poll (module I)
