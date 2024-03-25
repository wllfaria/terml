type key_code = Escape | Char of string | Up | Down | Left | Right
type key_modifiers = Shift | Ctrl | Alt | Super | Hyper | Meta
type key_event = { code : key_code; modifier : key_modifiers option }
type t = Key of key_event

let handle_csi_key key =
  match key with _ -> Key { code = Escape; modifier = None }

(** [handle_csi ()] handles the case where we have a control sequence introducer.

    This function decides what to do next based on the next key read from the input source.
    - if the next key is a \[, we may have an arrow, function key or other special key;
    - if not, we just return the escape key event.
*)
let handle_csi (module I : Input_source.t) =
  match I.read () with
  | `Read "[" -> (
      match I.read () with
      | `Read "A" -> Key { code = Up; modifier = None }
      | `Read "B" -> Key { code = Down; modifier = None }
      | `Read "C" -> Key { code = Right; modifier = None }
      | `Read "D" -> Key { code = Left; modifier = None }
      | `Read key -> handle_csi_key key
      | _ -> Key { code = Escape; modifier = None })
  | _ -> Key { code = Escape; modifier = None }

(** [next_event ()] reads the next key event from the input source.

    This function reads from the input source and returns a key event if it finds one.
    If it doesn't find a key event, it returns None.

    events read from the input source (e.g. stdin) are then converted into key events 
    that can be used by the application.
*)
let next_event (module I : Input_source.t) =
  match I.read () with
  | `Read "\x1b" ->
      (* we just found an control sequence introducer, so we may need to read more bytes
         to determine the actual sequence.
      *)
      Some (handle_csi (module I))
  | `Read c when c >= "\x01" && c <= "\x1A" ->
      (* ctrl + key is represented as a byte with the value range 1-26 (a-z).
         so when we find a ctrl+key sequence, we need to convert that key into the actual key
         with the ctrl modifier. `a` is represented as 97 in ascii, so we need to add 96 to get
         the actual value of the key.
      *)
      let code = c.[0] |> Char.code |> ( + ) 96 |> Char.chr |> String.make 1 in
      Some (Key { code = Char code; modifier = Some Ctrl })
  | `Read c ->
      (* we haven't found any special sequence, so we just return the key without modifiers *)
      Some (Key { code = Char c; modifier = None })
  | _ ->
      (* any other case, we just return none as we either couldn't read this event
         or it's not a key event.

         TODO: i need to look up what may happen when there's a malformed key event.
      *)
      None

(** [poll ()] returns a channel that will be populated with key events 
    as they are read from the input source. (e.g. stdin)

    This function spawns a new thead that will read from the input source
    to avoid blocking the main thread.
*)
let poll () =
  let channel = Event.new_channel () in
  Thread.create
    (fun () ->
      while true do
        let event = next_event (module Input.Input) in
        match event with
        | Some ev -> Event.sync (Event.send channel ev)
        | None -> ()
      done)
    ()
  |> ignore;
  channel

(* just a wrapper over `Input.read()` so users can use directly *)
let read () = Input.Input.read ()
