# Numo::OpenBLAS

[![Build Status](https://github.com/yoshoku/numo-openblas/workflows/build/badge.svg)](https://github.com/yoshoku/numo-openblas/actions?query=workflow%3Abuild)
[![Gem Version](https://badge.fury.io/rb/numo-openblas.svg)](https://badge.fury.io/rb/numo-openblas)
[![BSD 3-Clause License](https://img.shields.io/badge/License-BSD%203--Clause-orange.svg)](https://github.com/yoshoku/numo-openblas/blob/main/LICENSE.txt)

Numo::OpenBLAS downloads and builds [OpenBLAS](https://www.openblas.net/) during installation and
uses that as a background library for [Numo::Linalg](https://github.com/ruby-numo/numo-linalg).

## Installation

Building LAPACK included with OpenBLAS requires Fortran compiler.

macOS:

    $ brew install gfortran

Ubuntu:

    $ sudo apt-get install gfortran

Add this line to your application's Gemfile:

```ruby
gem 'numo-openblas'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install numo-openblas

Note:
Numo::OpenBLAS downloads and builds OpenBLAS during installation. In many cases, building OpenBLAS takes a lot of time.
In addtion, the building OpenBLAS may fail on Apple M1 mac due to linker error:

```sh
ld: warning: object file (...) was built for newer macOS version (...) than being linked (...)
...
Undefined symbols for architecture arm64:
  "___chkstk_darwin", referenced from:
  _sgemv_ in libopenblas_vortexp-r0.3.19.a(sgemv.o)
  _sger_ in libopenblas_vortexp-r0.3.19.a(sger.o)
  _cblas_sgemv in libopenblas_vortexp-r0.3.19.a(cblas_sgemv.o)
  _cblas_sger in libopenblas_vortexp-r0.3.19.a(cblas_sger.o)
  _dgemv_ in libopenblas_vortexp-r0.3.19.a(dgemv.o)
  _dger_ in libopenblas_vortexp-r0.3.19.a(dger.o)
  _cblas_dgemv in libopenblas_vortexp-r0.3.19.a(cblas_dgemv.o)
  ...
ld: symbol(s) not found for architecture arm64
```

In that case, you can install it by giving `MACOSX_DEPLOYMENT_TARGET` your mac version.
If you are using macOS Monterey, the installation command would be:

    $ MACOSX_DEPLOYMENT_TARGET=12.0 gem install numo-openblas

## Usage

Numo::OpenBLAS loads Numo::NArray and Numo::Linalg using OpenBLAS as a background library.
You can use Numo::NArray and Numo::Linalg just by loading Numo::OpenBLAS.

```ruby
require 'numo/openblas'

x = Numo::DFloat.new(5, 2).rand
c = x.transpose.dot(x)
eig_val, eig_vec = Numo::Linalg.eigh(c)
```

Moreover, some of the build options are defined by constants.

```ruby
> Numo::OpenBLAS::OPENBLAS_VERSION
=> " OpenBLAS 0.3.10 "
> Numo::OpenBLAS::OPENBLAS_CHAR_CORENAME
=> "HASWELL"
> Numo::OpenBLAS::OPENBLAS_NUM_CORES
=> 8
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yoshoku/numo-openblas.
This project is intended to be a safe, welcoming space for collaboration,
and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [BSD-3-Clause License](https://opensource.org/licenses/BSD-3-Clause).
