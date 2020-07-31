require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

require 'rake/extensiontask'

task build: :compile

Rake::ExtensionTask.new('openblas') do |ext|
  ext.ext_dir = 'ext/numo/openblas'
  ext.lib_dir = 'lib/numo/openblas'
end

task default: %i[clobber compile spec]
