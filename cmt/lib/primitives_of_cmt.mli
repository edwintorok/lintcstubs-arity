(*
 * Copyright (C) Cloud Software Group, Inc.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation; version 2.1 only. with the special
 * exception on linking described in file LICENSE.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *)

(** [Typedtree] has an unstable API (depends on compiler version),
    so extract the parts we need and convert to types defined in this file.
    If the build breaks with new compiler versions then only this module needs
    to be updated (perhaps by using Dune's support to conditionally select
    files based on compiler versions)
*)

type native_arg =
  | Value
  | Double
  | Int32
  | Int64
  | Intnat of {untagged_int: bool}
  | Bytecode_argv
  | Bytecode_argn

val ctype_of_native_arg : native_arg -> string
(**  [ctype_of_native_arg arg] returns the C type used when implementing
     primitives for native code mode.

    @see <https://v2.ocaml.org/manual/intfc.html#ss:c-unboxed> on the use of [intnat]*)

type t = {
    byte_name: string
        (** name of C function implementing the primitive in bytecode mode *)
  ; native_name: string
        (** name of C function implementinmg the primitive in native code mode *)
  ; arity: int  (** number of arguments to C function in native code mode *)
  ; alloc: bool  (** whether it allocates/raises exceptions *)
  ; native_result: native_arg
        (** result type of the C function implementing the primitive in native code mode*)
  ; native_args: native_arg list
        (** type of the arguments of the C function implementing the primitive in native code mode *)
}

val iter_primitives_exn : path:string -> (Types.type_expr -> t -> unit) -> unit
(** [iter_primitives_exn ~path primitive_description] will load the .cmt/.cmti file
 [path] and iterate on any primitives defined using [primitive_description].

  Exceptions from compiler-libs may escape, so it is recommended to wrap calls
  using {!val:with_report_exceptions}.
 *)

val with_report_exceptions : (unit -> 'a) -> 'a
(** [with_report_exceptions f] will report any compiler-libs exceptions
    escaping from [f] and exit the process with code 2. *)
