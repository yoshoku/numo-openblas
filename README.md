# Numo::OpenBLAS

Numo::OpenBLAS downloads and builds [OpenBLAS](https://www.openblas.net/) during installation and
uses that as a background library for [Numo::Linalg](https://github.com/ruby-numo/numo-linalg).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'numo-openblas'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install numo-openblas

Note: Numo::OpenBLAS downloads and builds OpenBLAS during installation.
In many cases, building OpenBLAS takes a lot of time.

## Usage

Numo::OpenBLAS loads Numo::NArray and Numo::Linalg using OpenBLAS as a background library.
You can use Numo::NArray and Numo::Linalg just by loading Numo::OpenBLAS.

```ruby
require 'numo/openblas'

x = Numo::DFloat.new(5, 2).rand
c = x.transpose.dot(x)
eig_val, eig_vec = Numo::Linalg.eigh(c)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yoshoku/numo-openblas. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/yoshoku/numo-openblas/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [BSD-3-Clause License](https://opensource.org/licenses/BSD-3-Clause).

## Code of Conduct

Everyone interacting in the Numo::Openblas project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/yoshoku/numo-openblas/blob/master/CODE_OF_CONDUCT.md).
