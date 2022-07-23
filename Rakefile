# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'

RuboCop::RakeTask.new

require 'rake/extensiontask'

task build: :compile # rubocop:disable Rake/Desc

Rake::ExtensionTask.new('openblas') do |ext|
  ext.ext_dir = 'ext/numo/openblas'
  ext.lib_dir = 'lib/numo/openblas'
end

task default: %i[clobber compile rubocop spec]
