module Input : Input_source.t = struct
  let stdin_fd = Unix.descr_of_in_channel stdin
  let decoder = Uutf.decoder ~encoding:`UTF_8 `Manual

  let uchar_to_str u =
    let buf = Buffer.create 8 in
    Uutf.Buffer.add_utf_8 buf u;
    Buffer.contents buf
  (**)
  (* let try_read () = *)
  (*   let buffer = Bytes.create 4096 in *)
  (*   let rec loop () = *)
  (*     let readable, _, _ = Unix.select [ stdin_fd ] [] [] 0.0001 in *)
  (*     if readable <> [] then *)
  (*       match Unix.read stdin_fd buffer 0 (Bytes.length buffer) with *)
  (*       | 0 -> () *)
  (*       | exception Unix.(Unix_error ((EINTR | EAGAIN | EWOULDBLOCK), _, _)) -> *)
  (*           () *)
  (*       | len -> *)
  (*           Uutf.Manual.src decoder buffer 0 len; *)
  (*           decode_loop (); *)
  (*           loop () *)
  (*   and decode_loop () = *)
  (*     match Uutf.decode decoder with *)
  (*     | `Uchar u -> *)
  (*         let _ = `Read (uchar_to_str u) in *)
  (*         decode_loop () *)
  (*     | `End -> () *)
  (*     | `Await -> () *)
  (*     | `Malformed _ -> () *)
  (*   in *)
  (*   loop () *)

  let try_read () =
    let bytes = Bytes.create 8 in
    let stdin, _, _ = Unix.select [ stdin_fd ] [] [] 0.0001 in
    if stdin = [] then ()
    else
      match Unix.read stdin_fd bytes 0 8 with
      | exception Unix.(Unix_error ((EINTR | EAGAIN | EWOULDBLOCK), _, _)) -> ()
      | len -> Uutf.Manual.src decoder bytes 0 len

  let read () =
    match Uutf.decode decoder with
    | `Uchar u -> `Read (uchar_to_str u)
    | `End -> `End
    | `Await ->
        try_read ();
        `Retry
    | `Malformed err -> `Malformed err
end
