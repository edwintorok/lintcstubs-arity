(** the C type of an argument *)
type native_arg =
  | Value  (** an OCaml value *)
  | Double  (** an unboxed double *)
  | Int32  (** an unboxed int32 *)
  | Int64  (** an unboxed int64 *)
  | Intnat of {untagged_int: bool}
      (** an unboxed intnat, 
          @see <https://v2.ocaml.org/manual/intfc.html#ss:c-unboxed> on the use of [intnat]*)
  | Bytecode_argv  (** bytecode argv when arity > 5 *)
  | Bytecode_argn  (** number of arguments when arity > 5 for bytecode *)
