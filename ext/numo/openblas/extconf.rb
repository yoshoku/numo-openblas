# frozen_string_literal: true

require 'digest/md5'
require 'etc'
require 'fileutils'
require 'mkmf'
require 'open-uri'
require 'open3'
require 'rubygems/package'

OPENBLAS_VER = '0.3.23'
OPENBLAS_KEY = '115634b39007de71eb7e75cf7591dfb2'
OPENBLAS_URI = "https://github.com/xianyi/OpenBLAS/archive/v#{OPENBLAS_VER}.tar.gz"
OPENBLAS_DIR = File.expand_path("#{__dir__}/../../../vendor")

unless File.exist?("#{OPENBLAS_DIR}/installed_#{OPENBLAS_VER}")
  URI.parse(OPENBLAS_URI).open { |f| File.binwrite("#{OPENBLAS_DIR}/tmp/openblas.tgz", f.read) }

  if Digest::MD5.file("#{OPENBLAS_DIR}/tmp/openblas.tgz").to_s != OPENBLAS_KEY
    abort('MD5 digest of downloaded file does not match.')
  end

  Gem::Package::TarReader.new(Zlib::GzipReader.open("#{OPENBLAS_DIR}/tmp/openblas.tgz")) do |tar|
    tar.each do |entry|
      next unless entry.file?

      filename = "#{OPENBLAS_DIR}/tmp/#{entry.full_name}"
      next if filename == File.dirname(filename)

      FileUtils.mkdir_p("#{OPENBLAS_DIR}/tmp/#{File.dirname(entry.full_name)}")
      File.binwrite(filename, entry.read)
      File.chmod(entry.header.mode, filename)
    end
  end

  Dir.chdir("#{OPENBLAS_DIR}/tmp/OpenBLAS-#{OPENBLAS_VER}") do
    mkstdout, _mkstderr, mkstatus = Open3.capture3("make -j#{Etc.nprocessors}")
    File.open("#{OPENBLAS_DIR}/tmp/openblas.log", 'w') { |f| f.puts(mkstdout) }
    unless mkstatus.success?
      abort("Failed to build OpenBLAS. Check the openblas.log file for more details: #{OPENBLAS_DIR}/tmp/openblas.log")
    end

    insstdout, _insstderr, insstatus = Open3.capture3("make install PREFIX=#{OPENBLAS_DIR}")
    File.open("#{OPENBLAS_DIR}/tmp/openblas.log", 'a') { |f| f.puts(insstdout) }
    unless insstatus.success?
      abort("Failed to install OpenBLAS. Check the openblas.log file for more details: #{OPENBLAS_DIR}/tmp/openblas.log")
    end

    FileUtils.touch("#{OPENBLAS_DIR}/installed_#{OPENBLAS_VER}")
  end
end

abort('libopenblas is not found.') unless find_library('openblas', nil, "#{OPENBLAS_DIR}/lib")

abort('openblas_config.h is not found.') unless find_header('openblas_config.h', nil, "#{OPENBLAS_DIR}/include")

create_makefile('numo/openblas/openblas')
