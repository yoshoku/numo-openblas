# frozen-string-literal: true

require 'numo/narray'
require 'numo/linalg/linalg'
require 'numo/openblas/version'
require 'numo/openblas/openblas'

Numo::Linalg::Loader.load_openblas(File.expand_path("#{__dir__}/../../vendor/lib/"))
