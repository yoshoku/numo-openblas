# frozen-string-literal: true

require 'numo/narray'
require 'numo/linalg/linalg'
require 'numo/openblas/version'
require 'numo/openblas/openblas'

module Numo
  module Linalg
    module Loader
      module_function

      def load_openblas
        dlext = case RbConfig::CONFIG['host_os']
                when /mswin|msys|mingw|cygwin/
                  'dll'
                when /darwin|mac os/
                  'dylib'
                else
                  'so'
                end
        openblas_path = File.expand_path(__dir__ + "/../../vendor/lib/libopenblas.#{dlext}")
        Numo::Linalg::Blas.dlopen(openblas_path)
        Numo::Linalg::Lapack.dlopen(openblas_path)
        @@libs = [openblas_path]
      end
    end
  end
end

Numo::Linalg::Loader.load_openblas
