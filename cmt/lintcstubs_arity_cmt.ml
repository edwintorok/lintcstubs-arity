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

(** Load a .cmt file which contains a Typedtree,
    and use it to extract primitives and generate a header.

    [ocamlc -dtypedtree foo.ml] can be used to see how the typedtree looks
    like.

    A Typedtree is better than a Parsetree for this purpose because it contains
    resolved types and type immediacy information from the compiler itself,
    and contains information about the native versions of the primitives (e.g. unboxed)
 *)

let usage_msg = Printf.sprintf "%s [FILE.cmt...]" Sys.executable_name

module StringSet = Set.Make (String)

let print_c_prototype res name args =
  let open Primitives_of_cmt in
  Printf.printf "CAMLprim %s %s(%s);\n" (ctype_of_native_arg res) name
  @@ String.concat ", "
  @@ List.map ctype_of_native_arg args

let print_c_prototype_arity arity byte_name =
  let open Primitives_of_cmt in
  print_c_prototype Value byte_name @@ List.init arity (fun _ -> Value)

let primitive_description _ desc =
  let open Primitives_of_cmt in
  (* print native first *)
  print_c_prototype desc.native_result desc.native_name desc.native_args ;
  (* if the bytecode one is different, print it *)
  if desc.native_name <> desc.byte_name then
    if desc.arity <= 5 then
      print_c_prototype_arity desc.arity desc.byte_name
    else
      print_c_prototype Value desc.byte_name [Bytecode_argv; Bytecode_argn]
  else
    (* according to https://v2.ocaml.org/manual/intfc.html#ss:c-prim-impl
       if the primitive takes more than 5 arguments then bytecode and native
       mode implementations must be different *)
    assert (desc.arity <= 5)

let () =
  let files =
    (* use Arg for parsing to minimize dependencies *)
    let lst = ref [] in
    Arg.parse [] (fun file -> lst := file :: !lst) usage_msg ;
    !lst
  in

  print_endline "/* AUTOGENERATED FILE, DO NOT EDIT */" ;
  (* [CAML_NAME_SPACE] is recommended by the manual *)
  print_endline "#define CAML_NAME_SPACE" ;

  (* avoid conflict on xentoollog, for 'vasprintf' *)
  print_endline "#define _GNU_SOURCE" ;

  (* get the definition of [value] *)
  print_endline "#include <caml/mlvalues.h>" ;

  Primitives_of_cmt.with_report_exceptions @@ fun () ->
  files
  |> List.iter @@ fun path ->
     Primitives_of_cmt.iter_primitives_exn ~path primitive_description
