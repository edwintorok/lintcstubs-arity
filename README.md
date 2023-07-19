Install:
```
opam install lintcstubs-arity
```

Usage:

```
lintcstubs_arity ocamlfile.ml >primitives.h
```

`ocamlfile.ml` is an OCaml file that declares a C primitive as defined [in the manual](https://v2.ocaml.org/manual/intfc.html).
Once `primitives.h` is generated you can include it in the `.c` files that implement the OCaml primitives defined in `ocamlfile.ml`.

This can help detect simple mismatches between the number of arguments declared in the `.ml` file and implemented in the `.c` file.
It is recommended to include the above generation step in the build process of the C stubs.
