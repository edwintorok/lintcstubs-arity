In this example there is an `external` declaration of a primitive in `foo.ml`.

To generate a C `foo.h` file with dune you can add the following rule (`%{cmt:module}` is not yet supported by dune):
```
(rule
 (action
  (with-stdout-to
   foo.h
   (run %{bin:lintcstubs_arity_cmt} %{dep:.foo.objs/byte/foo.cmt}))))
```

Then add an `#include` statement to the `.c` file:
```c
#include "foo.h"
```

Dune will automatically know that it needs to build `foo.h`.

This requires `lintcstubs_arity_cmt` to be on `$PATH` or somewhere `dune` can find (e.g., by installing it through `opam` or in an `opam monorepo` setup). 

(Tested with dune 3.10, but should work with dune 2.7 too)

# Editor integration

The OCaml headers are usually not on default include paths, and `foo.h` is only available in the build directory.
Editors with language server integrations (e.g., using `clangd` as language server) won't be able to find these,
and show an error at the `#include` lines.

For better LSP integration the following rule can be added to dune (this is useful even without auto-generated headers):
```
(rule
 ; editor integration: generate include paths for LSPs such as clangd
 (target compile_flags.txt)
 (mode promote)
 (enabled_if
  (= %{system} linux))
 (action
  (with-stdout-to
   compile_flags.txt
   (pipe-stdout
    (progn
     (echo %{ocaml-config:ocamlc_cppflags} %{ocaml-config:ocamlc_cflags}
       -I%{ocaml_where} -I)
     (system pwd))
    (system "xargs -n1 echo") ; the format is a single flag per line
    ))))
```

You can also enable some additional warning options in your editor, see the [dune](dune) file for a full example.

# OCaml 4.08 &ndash; 4.10

For older versions of OCaml you can use `lintcstubs_arity` instead, see the [dune](dune) file on how to chose between the tools based on the compiler version.
