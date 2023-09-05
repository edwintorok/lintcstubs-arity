# From the manual: https://v2.ocaml.org/manual/depend.html#s:ocamldep-makefile
OCAMLC=ocamlc
OCAMLOPT=ocamlopt
OCAMLDEP=ocamldep
OCAMLMKLIB=ocamlmklib
INCLUDES=                 # all relevant -I options here
OCAMLFLAGS=$(INCLUDES)    # add other options for ocamlc here
OCAMLOPTFLAGS=$(INCLUDES) # add other options for ocamlopt here

#
.PHONY: all
all: prog1.byte prog1.native

# Common rules

%.cmo: %.ml
		$(OCAMLC) $(OCAMLFLAGS) -c $<

%.cmi: %.mli
		$(OCAMLC) $(OCAMLFLAGS) -c $<

%.cmx: %.ml
		$(OCAMLOPT) $(OCAMLOPTFLAGS) -c $<

# Clean up
.PHONY: clean
clean:
		rm -f *.native *.byte .depend
		rm -f *.a *.o *.h *.cm* *.so
		rm -f lintcstubs_arity

# Dependencies
.depend:
		$(OCAMLDEP) $(INCLUDES) *.mli *.ml > .depend

include .depend

# Compile prog1 for both bytecode and native code

# The list of object files for prog1
PROG1_OBJS=prog1.cmo
PROG1_OBJS_NATIVE=prog1.cmx

prog1.cmo: foo.cma
prog1.cmx: foo.cmxa

prog1.byte: foo.cma libfoo.a $(PROG1_OBJS)
		$(OCAMLC) -custom -o $@ $(OCAMLFLAGS) -ccopt -L. $^
		
prog1.native: foo.cmxa libfoo.a $(PROG1_OBJS_NATIVE)
		$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) -ccopt -L. $^

# Additional rules for building C stubs
%.o: %.c
		$(OCAMLC) -c $< -o $@

#  From the manual https://v2.ocaml.org/manual/intfc.html#s:ocamlmklib
%.cma: %.cmo
		$(OCAMLMKLIB) -o $* $<

%.cmxa: %.cmx
		$(OCAMLMKLIB) -o $* $<

dll%.so lib%.a: %stubs.o
		$(OCAMLMKLIB) -o $* $<

.PRECIOUS: %.cmo %.o %.cmx

# LINTER: the C stub depends on the auto-generated header
foostubs.c: foo.h

# LINTER: build header generator
lintcstubs_arity: lintcstubs_arity.ml
		$(OCAMLC) -I +compiler-libs -o $@ ocamlcommon.cma $<

# LINTER: rule to auto-generate headers from .ml file
%.h: %.ml lintcstubs_arity
		./lintcstubs_arity $< >$@