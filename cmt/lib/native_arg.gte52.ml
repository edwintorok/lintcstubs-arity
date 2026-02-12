open Ptypes

let native_arg_of_primitive arg =
  let open Primitive in
  match arg with
  | Same_as_ocaml_repr ->
      Value
  | Unboxed_float ->
      Double
  | Unboxed_integer Pnativeint ->
      Intnat {untagged_int= false}
  | Unboxed_integer Pint32 ->
      Int32
  | Unboxed_integer Pint64 ->
      Int64
  | Untagged_immediate ->
      (* the range of this is one bit less than Pnativeint, but still same type on C side *)
      Intnat {untagged_int= true}
