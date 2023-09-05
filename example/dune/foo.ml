(* Based on example from https://v2.ocaml.org/manual/intfc.html#ss:c-unboxed *)

external foo : float -> float -> float = "foo_byte" "foo" [@@unboxed]
