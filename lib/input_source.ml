module type t = sig
  val enqueue : string list -> unit
  val queue : string Queue.t
  val read : unit -> [ `Read of string | `End | `Retry | `Malformed of string ]
end
