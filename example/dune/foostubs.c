#include "foo.h"

#include <caml/mlvalues.h>
#include <caml/alloc.h>

CAMLprim double foo(double a, double b)
{
    return a + b;
}

CAMLprim value foo_byte(value a, value b)
{
  return caml_copy_double(foo(Double_val(a), Double_val(b)));
}