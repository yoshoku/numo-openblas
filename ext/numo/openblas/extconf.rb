# frozen-string-literal: true

require 'digest/sha1'
require 'etc'
require 'fileutils'
require 'mkmf'
require 'open-uri'
require 'open3'
require 'rubygems/package'

OPENBLAS_VER = '0.3.16'
OPENBLAS_KEY = 'dbb76d2316a135a8e73c98c926c8a596b3bb233f'
OPENBLAS_URI = "https://github.com/xianyi/OpenBLAS/archive/v#{OPENBLAS_VER}.tar.gz"
OPENBLAS_DIR = File.expand_path(__dir__ + '/../../../vendor')

unless File.exist?("#{OPENBLAS_DIR}/installed_#{OPENBLAS_VER}")
  puts "Downloading OpenBLAS #{OPENBLAS_VER}."
  URI.open(OPENBLAS_URI) do |rf|
    File.open("#{OPENBLAS_DIR}/tmp/openblas.tgz", 'wb') { |sf| sf.write(rf.read) }
  end

  if OPENBLAS_KEY != Digest::SHA1.file("#{OPENBLAS_DIR}/tmp/openblas.tgz").to_s
    puts 'SHA1 digest of downloaded file does not match.'
    exit(1)
  end

  puts 'Unpacking OpenBLAS tar.gz file.'
  Gem::Package::TarReader.new(Zlib::GzipReader.open("#{OPENBLAS_DIR}/tmp/openblas.tgz")) do |tar|
    tar.each do |entry|
      next unless entry.file?

      filename = "#{OPENBLAS_DIR}/tmp/#{entry.full_name}"
      next if filename == File.dirname(filename)

      FileUtils.mkdir_p("#{OPENBLAS_DIR}/tmp/#{File.dirname(entry.full_name)}")
      File.open(filename, 'wb') { |f| f.write(entry.read) }
      File.chmod(entry.header.mode, filename)
    end
  end

  Dir.chdir("#{OPENBLAS_DIR}/tmp/OpenBLAS-#{OPENBLAS_VER}") do
    puts 'Building OpenBLAS. This could take a while...'
    mkstdout, _mkstderr, mkstatus = Open3.capture3("make -j#{Etc.nprocessors}")
    File.open("#{OPENBLAS_DIR}/tmp/openblas.log", 'w') { |f| f.puts(mkstdout) }
    unless mkstatus.success?
      puts 'Failed to build OpenBLAS.'
      puts 'Check the openblas.log file for more details:'
      puts "#{OPENBLAS_DIR}/tmp/openblas.log"
      exit(1)
    end

    puts 'Installing OpenBLAS.'
    insstdout, _insstderr, insstatus = Open3.capture3("make install PREFIX=#{OPENBLAS_DIR}")
    File.open("#{OPENBLAS_DIR}/tmp/openblas.log", 'a') { |f| f.puts(insstdout) }
    unless insstatus.success?
      puts 'Failed to install OpenBLAS.'
      puts 'Check the openblas.log file for more details:'
      puts "#{OPENBLAS_DIR}/tmp/openblas.log"
      exit(1)
    end

    FileUtils.touch("#{OPENBLAS_DIR}/installed_#{OPENBLAS_VER}")
  end
end

unless find_library('openblas', nil, "#{OPENBLAS_DIR}/lib")
  puts 'libopenblas is not found.'
  exit(1)
end

unless find_header('openblas_config.h', nil, "#{OPENBLAS_DIR}/include")
  puts 'openblas_config.h is not found.'
  exit(1)
end

create_makefile('numo/openblas/openblas')
