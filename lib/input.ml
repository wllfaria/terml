module Input : Input_source.t = struct
  let queue =
    failwith "Input.queue is only available in the virtual input source"

  let enqueue _ =
    failwith "Input.enqueue is only available in the virtual input source"

  let stdin_fd = Unix.descr_of_in_channel stdin
  let decoder = Uutf.decoder ~encoding:`UTF_8 `Manual

  let try_read () =
    let bytes = Bytes.create 8 in
    let stdin, _, _ = Unix.select [ stdin_fd ] [] [] 0.0001 in
    if stdin = [] then ()
    else
      match Unix.read stdin_fd bytes 0 8 with
      | exception Unix.(Unix_error ((EINTR | EAGAIN | EWOULDBLOCK), _, _)) -> ()
      | len -> Uutf.Manual.src decoder bytes 0 len

  let uchar_to_str u =
    let buf = Buffer.create 8 in
    Uutf.Buffer.add_utf_8 buf u;
    Buffer.contents buf

  let read () =
    match Uutf.decode decoder with
    | `Uchar u -> `Read (uchar_to_str u)
    | `End -> `End
    | `Await ->
        try_read ();
        `Retry
    | `Malformed err -> `Malformed err
end
