In this example there is an `external` declaration of a primitive in `foo.ml`.

To generate a C `foo.h` file with a Makefile you can add the following rules:
```make
foostubs.c: foo.h

%.h: %.ml lintcstubs_arity
		./lintcstubs_arity $< >$@%.h: %.cmt
```

You can build the tool as part of your build system (it is a single `.ml` file that only depends on
`compiler-libs` which is shipped by the compiler itself):
```make
lintcstubs_arity: lintcstubs_arity.ml
		$(OCAMLC) -I +compiler-libs -o $@ ocamlcommon.cma $<
```

It is not necessary to generate a `.cmt` file in this case.

Then add an `#include` statement to the `.c` file:
```c
#include "foo.h"
```

This works with OCaml 4.08+, but only supports bytecode versions of the primitives.
(with unboxed annotations, or more than 5 arguments 2 separate implementations have to be provided in C).

See the full example in [the Makefile](Makefile).

For full support, including unboxed annotations see [example/Makefile](../Makefile/README.md) instead,
but that requires OCaml 4.10+.