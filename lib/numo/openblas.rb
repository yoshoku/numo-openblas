# frozen_string_literal: true

require 'numo/narray'
require 'numo/linalg/linalg'
require 'numo/openblas/version'
require 'numo/openblas/openblas'

case RUBY_PLATFORM
when /mswin|msys|mingw|cygwin/
  lib_dir = 'bin'
else
  lib_dir = 'lib'
end

Numo::Linalg::Loader.load_openblas(File.expand_path("#{__dir__}/../../vendor/#{lib_dir}/"))
