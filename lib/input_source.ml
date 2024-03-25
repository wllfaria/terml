module type t = sig
  val read : unit -> [ `Read of string | `End | `Retry | `Malformed of string ]
end
