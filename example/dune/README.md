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

For better LSP integration the [`dune-compiledb`](https://github.com/edwintorok/dune-compiledb/) tool can be used:
```
dune rules | dune-compiledb <project-root> [...additional flags]
```

# OCaml 4.08 &ndash; 4.10

For older versions of OCaml you can use `lintcstubs_arity` instead, see the [dune](dune) file on how to choose between the tools based on the compiler version.
