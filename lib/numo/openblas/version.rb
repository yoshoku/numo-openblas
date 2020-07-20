# frozen_string_literal: true

module Numo
  # Numo::OpenBLAS loads Numo::NArray and Linalg with OpenBLAS used as backend library.
  module OpenBLAS
    # The version of Numo::OpenBLAS you install.
    VERSION = '0.1.0'

    # The version OpenBLAS that Numo::OpenBLAS build and use.
    OPENBLAS_VERSION = '0.3.10'

    # The URI of OpenBLAS that Numo::OpenBLAS installed.
    OPENBLAS_URI = "https://github.com/xianyi/OpenBLAS/archive/v#{OPENBLAS_VERSION}.tar.gz"

    # The install directory of OpenBLAS.
    INSTALL_DIR = File.expand_path(__dir__ + '/../../../vendor')
  end
end
