# frozen-string-literal: true

require 'digest/sha1'
require 'etc'
require 'fileutils'
require 'mkmf'
require 'open-uri'
require 'open3'
require 'rubygems/package'

OPENBLAS_VER = '0.3.21'
OPENBLAS_KEY = 'b052d196ad694b29302e074b3eb8cc66745f6e2f'
OPENBLAS_URI = "https://github.com/xianyi/OpenBLAS/archive/v#{OPENBLAS_VER}.tar.gz"
OPENBLAS_DIR = File.expand_path(__dir__ + '/../../../vendor')

unless File.exist?("#{OPENBLAS_DIR}/installed_#{OPENBLAS_VER}")
  URI.open(OPENBLAS_URI) do |rf|
    File.open("#{OPENBLAS_DIR}/tmp/openblas.tgz", 'wb') { |sf| sf.write(rf.read) }
  end

  abort('SHA1 digest of downloaded file does not match.') if OPENBLAS_KEY != Digest::SHA1.file("#{OPENBLAS_DIR}/tmp/openblas.tgz").to_s

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
    mkstdout, _mkstderr, mkstatus = Open3.capture3("make -j#{Etc.nprocessors}")
    File.open("#{OPENBLAS_DIR}/tmp/openblas.log", 'w') { |f| f.puts(mkstdout) }
    abort("Failed to build OpenBLAS. Check the openblas.log file for more details: #{OPENBLAS_DIR}/tmp/openblas.log") unless mkstatus.success?

    insstdout, _insstderr, insstatus = Open3.capture3("make install PREFIX=#{OPENBLAS_DIR}")
    File.open("#{OPENBLAS_DIR}/tmp/openblas.log", 'a') { |f| f.puts(insstdout) }
    abort("Failed to install OpenBLAS. Check the openblas.log file for more details: #{OPENBLAS_DIR}/tmp/openblas.log") unless insstatus.success?

    FileUtils.touch("#{OPENBLAS_DIR}/installed_#{OPENBLAS_VER}")
  end
end

abort('libopenblas is not found.') unless find_library('openblas', nil, "#{OPENBLAS_DIR}/lib")

abort('openblas_config.h is not found.') unless find_header('openblas_config.h', nil, "#{OPENBLAS_DIR}/include")

create_makefile('numo/openblas/openblas')
