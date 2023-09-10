![Build and test](https://github.com/edwintorok/lintcstubs-arity/actions/workflows/workflow.yml/badge.svg)

`Lintcstubs_arity` — check consistency between OCaml primitive declarations and implementation
==============================================================================================

These are a suite of tools and libraries for finding mismatches between the number of arguments declared in a `.ml` file for a C primitive and its implementation in the corresponding `.c` file.

* `lintcstubs_arity` is a tool that generates a C header file from an OCaml `.ml` file that contains `external` declarations
* `lintcstubs_arity_cmt` generates the header file from a `.cmt` file instead.
* `lintcstubs-arity.primitives_of_cmt` is an OCaml library that can be used to iterate over all primitive declarations in a `.cmt` file.

Their only dependency is `compiler-libs` which is shipped with the compiler distribution.
Requires OCaml 4.10+.

# Installation

## Using `opam`

```
opam install lintcstubs-arity
```

## Minimal

If you do not use `opam` or `dune` it is still possible to use this tool, see [example/minimal](example/minimal/README.md) for details.

# Why?

If the number or type of arguments doesn't match between the declaration in the `.ml` file or its implementation in `.c` then this can result in undefined behaviour at runtime.
Neither the C nor OCaml compiler is aware of the requirements of the other module, and the linker only checks the presence of the `symbol`, but not its type.
By generating a `.h` file such mismatches can be detected at build time by the C compiler.

The [paper](https://arxiv.org/abs/2307.14909) contains concrete examples of how such mismatches can occur in practice as software evolves.

# Usage:

Consult the [official](https://v2.ocaml.org/manual/intfc.html#ss:c-prim-impl)
[manual](https://v2.ocaml.org/manual/intfc.html#ss:c-unboxed) on how to implement C primitives correctly.

## Bytecode & native code stubs
```
lintcstubs_arity_cmt ocamlfile.cmt >primitives.h
```

The generated `primitives.h` can be included at the top of the `.c` file implementing the OCaml primitives.

`ocamlfile.cmt` is a `-bin-annot` file for `ocamlfile.ml`. Your build system should've produced one, check that it is using the `-bin-annot` flag if not.
You can also create one manually (add include and `ocamlfind` flags as necessary):
```
ocamlc -bin-annot -c ocamlfile.ml
```

For more details see the build-system integration examples:

* [dune](example/dune/README.md)
* [make](example/Makefile/README.md)

You can also commit the generated file to source control, thus requiring the tool to be present
only when changing the `.ml` file (or in a CI). This can be useful when the OCaml module is part of a larger system predominantly written in another language.

This is the recommended version of the tool if you meet the OCaml version requirements and can integrate header generation into the package's build system. The generated header contains both byte-code and native-code prototypes,
and supports unboxed annotations.

## Bytecode only

```
lintcstubs_arity ocamlfile.ml >primitives.h
```

`ocamlfile.ml` is an OCaml file that declares a C primitive as defined [in the manual](https://v2.ocaml.org/manual/intfc.html).

After `primitives.h` is generated, you can include it in the `.c` files that implement the OCaml primitives defined in `ocamlfile.ml`.

This can help detect simple mismatches between the number of arguments declared in the `.ml` file and implemented in the `.c` file.

This version of the tool doesn't support unboxed arguments, and therefore it doesn't generate prototypes for native code versions of the stubs. It only requires a source file and doesn't require setting up build paths or integrating into a build system, it is suitable to use on an unpacked source tarball directly.


# How it works

This is part of a suite of static analysis tools for C stubs described in a [paper](https://arxiv.org/abs/2307.14909) submitted to the [OCaml 2023 workshop](https://icfp23.sigplan.org/details/ocaml-2023-papers/10/Targeted-Static-Analysis-for-OCaml-C-Stubs-Eliminating-gremlins-from-the-code).

If there is interest, its integration could be proposed into a future version of the compiler.

# Design principles

All of these tools adhere to these principles:

* No external dependencies (`compiler-libs` is available by default) to make it easy to reuse in other build systems
* Optional dependencies for ecosystem integration (e.g., `dune`, or `make`)
* Use the minimum version of Dune that has the features we require (e.g., `cram` tests)
* Both of these tools rely on unstable compiler APIs. They use just the minimum information from the Parse- and Typed-trees to ensure the tool works on a wide range of OCaml compiler versions (and is easy to adapt if it breaks). Shape-analysis is out-of-scope.
* Contains [Cram tests](https://dune.readthedocs.io/en/stable/tests.html#cram-tests) to check for correct behaviour.

