(lang dune 2.7)
(cram enable)
(implicit_transitive_deps false)

(generate_opam_files)
(name lintcstubs-arity)
(source (github edwintorok/lintcstubs-arity))
(authors "Edwin Török <edwin.torok@cloud.com>")
(maintainers "Edwin Török <edwin.torok@cloud.com>")
(license LGPL-2.1-or-later)

(package
 (name lintcstubs-arity)
 (synopsis "Generate headers for C bindings")
 (description "Generates .h files from 'external' declarations in .ml or .cmt files. Can be used to spot mismatches in number of arguments between C primitive declared in OCaml and its implementation in the .c file.")
 (depends
  (ocaml (>= 4.10))
 )
 (depopts
  (ocaml-src (and :with-test))
 )
)