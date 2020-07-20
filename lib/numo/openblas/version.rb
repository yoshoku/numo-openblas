# frozen_string_literal: true

module Numo
  # Numo::OpenBLAS loads Numo::NArray and Linalg with OpenBLAS used as backend library.
  module OpenBLAS
    # The version of Numo::OpenBLAS you install.
    VERSION = '0.1.0'

    # The version OpenBLAS that Numo::OpenBLAS build and use.
    OPENBLAS_VERSION = '0.3.10'
  end
end
