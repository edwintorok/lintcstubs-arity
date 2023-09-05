In this example there is an `external` declaration of a primitive in `foo.ml`.

To generate a C `foo.h` file with a Makefile you can add the following rules:
```make
foostubs.c: foo.h

%.h: %.cmt
		lintcstubs_arity_cmt $< >$@
```

You will need to modify your Makefile if it doesn't already generate a `.cmt` file.
Pick one of `ocamlc` or `ocamlopt` and add the `-bin-annot` flag (but not both to avoid problems with build parallelism):
```make
%.cmt %.cmo: %.ml
		$(OCAMLC) $(OCAMLFLAGS) -bin-annot -c $<
```

Then add an `#include` statement to the `.c` file:
```c
#include "foo.h"
```

The `lintcstubs_arity_cmt` must be on `$PATH` (e.g. by installing it through `opam`).

See the full example in [the Makefile](Makefile).

# OCaml 4.08 - 4.10

See [example/minimal](../minimal/README.md) for older versions of OCaml, or if you don't want to depend on the tool being installed.