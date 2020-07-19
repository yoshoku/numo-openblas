require_relative 'lib/numo/openblas/version'

Gem::Specification.new do |spec|
  spec.name          = 'numo-openblas'
  spec.version       = Numo::OpenBLAS::VERSION
  spec.authors       = ['yoshoku']
  spec.email         = ['yoshoku@outlook.com']

  spec.summary       = <<~MSG
    Numo::OpenBLAS downloads and builds OpenBLAS during installation and
    uses that as a background library for Numo::Linalg.
  MSG
  spec.description   = <<~MSG
    Numo::OpenBLAS downloads and builds OpenBLAS during installation and
    uses that as a background library for Numo::Linalg.
  MSG
  spec.homepage      = 'https://github.com/yoshoku/numo-openblas'
  spec.license       = 'BSD-3-Clause'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/yoshoku/numo-openblas'
  spec.metadata['changelog_uri'] = 'https://github.com/yoshoku/numo-openblas/blob/master/CHANGELOG.md'
  spec.metadata['documentation_uri'] = 'https://github.com/yoshoku/numo-openblas/blob/master/README.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'numo-linalg', '~> 0.1', '>= 0.1.4'
  spec.add_runtime_dependency 'numo-narray', '~> 0.9', '>= 0.9.1'
end
