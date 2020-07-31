/**
 * Numo::OpenBLAS downloads and builds OpenBLAS during installation and
 * uses that as a background library for Numo::Linalg.
 */

#include <ruby.h>
#include <openblas_config.h>

VALUE mNumo;
VALUE mOpenBLAS;

void Init_openblas()
{
  /**
  * Document-module: Numo
  * Numo is the top level namespace of NUmerical MOdules for Ruby.
  */
  mNumo = rb_define_module("Numo");

  /**
   * Document-module: Numo::Liblinear
   * Numo::OpenBLAS loads Numo::NArray and Linalg with OpenBLAS used as backend library.
   */
  mOpenBLAS = rb_define_module_under(mNumo, "OpenBLAS");

  /* The number of cores detected by OpenBLAS. */
  rb_define_const(mOpenBLAS, "OPENBLAS_NUM_CORES", INT2NUM(OPENBLAS_NUM_CORES));

  /* The core name detected by OpenBLAS. */
  rb_define_const(mOpenBLAS, "OPENBLAS_CHAR_CORENAME", rb_str_new_cstr(OPENBLAS_CHAR_CORENAME));

  /* The version of OpenBLAS used in background library. */
  rb_define_const(mOpenBLAS, "OPENBLAS_VERSION", rb_str_new_cstr(OPENBLAS_VERSION));
}
