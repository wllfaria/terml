type key_code = Escape | Char of string | Up | Down | Left | Right
type key_modifiers = Shift | Ctrl | Alt | Super | Hyper | Meta
type key_event = { code : key_code; modifiers : key_modifiers option }
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

let read () = Input.Input.read ()

let next_event (module I : Input_source.t) =
  match I.read () with
  | `Read "\x1b" -> None
  | `Read c -> Some (Key { code = Char c; modifiers = None })
  | `Retry -> None
  | _ -> None

let poll () =
  let channel = Event.new_channel () in
  let _ =
    Thread.create
      (fun () ->
        while true do
          let event = next_event (module Input.Input) in
          match event with
          | Some ev ->
              let _ =
                match ev with
                | Key { code = Char c; _ } ->
                    Printf.printf "sending key: %s\n" c;
                    flush stdout
                | _ -> ()
              in
              let _ = Event.send channel ev in
              ()
          | None -> ()
        done)
      ()
  in
  channel
