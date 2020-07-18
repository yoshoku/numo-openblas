# frozen-string-literal: true

require 'rubygems'
require 'rubygems/package'
require 'etc'
require 'fileutils'
require 'open-uri'
require 'open3'

Gem.post_install do
  OPENBLAS_VERSION = '0.3.10'
  OPENBLAS_URI = "https://github.com/xianyi/OpenBLAS/archive/v#{OPENBLAS_VERSION}.tar.gz"
  OPENBLAS_VENDOR_DIR = File.expand_path(__dir__ + '/../vendor')
  OPENBLAS_TGZ = "#{OPENBLAS_VENDOR_DIR}/tmp/openblas.tgz"
  OPENBLAS_LOG = "#{OPENBLAS_VENDOR_DIR}/tmp/openblas.log"

  unless File.exist?("#{OPENBLAS_VENDOR_DIR}/installed_#{OPENBLAS_VERSION}")
    puts "Downloading OpenBLAS #{OPENBLAS_VERSION}."
    URI.open(OPENBLAS_URI) { |rf| File.open(OPENBLAS_TGZ, 'wb') { |sf| sf.write(rf.read) } }

    puts 'Unpacking OpenBLAS tar.gz file.'
    Gem::Package::TarReader.new(Zlib::GzipReader.open(OPENBLAS_TGZ)) do |tar|
      tar.each do |entry|
        next unless entry.file?

        filename = "#{OPENBLAS_VENDOR_DIR}/tmp/#{entry.full_name}"
        next if filename == File.dirname(filename)

        FileUtils.mkdir_p("#{OPENBLAS_VENDOR_DIR}/tmp/#{File.dirname(entry.full_name)}")
        File.open(filename, 'wb') { |f| f.write(entry.read) }
        File.chmod(entry.header.mode, filename)
      end
    end

    Dir.chdir("#{OPENBLAS_VENDOR_DIR}/tmp/OpenBLAS-#{OPENBLAS_VERSION}") do
      puts 'Building OpenBLAS. This could take a while...'
      mkstdout, _mkstderr, mkstatus = Open3.capture3("make -j#{Etc.nprocessors}")
      File.open(OPENBLAS_LOG, 'w') { |f| f.puts(mkstdout) }
      unless mkstatus.success?
        puts 'Failed to build OpenBLAS.'
        puts 'Check the make-openblas.log file for more details:'
        puts OPENBLAS_LOG
        break
      end
      puts 'Installing OpenBLAS.'
      insstdout, _insstderr, insstatus = Open3.capture3("make install PREFIX=#{OPENBLAS_VENDOR_DIR}")
      File.open(OPENBLAS_LOG, 'a') { |f| f.puts(insstdout) }
      unless insstatus.success?
        puts 'Failed to install OpenBLAS.'
        puts 'Check the make-openblas.log file for more details:'
        puts OPENBLAS_LOG
      end
    end

    FileUtils.touch("#{OPENBLAS_VENDOR_DIR}/installed_#{OPENBLAS_VERSION}")
  end

  Object.send(:remove_const, :OPENBLAS_VERSION)
  Object.send(:remove_const, :OPENBLAS_URI)
  Object.send(:remove_const, :OPENBLAS_VENDOR_DIR)
  Object.send(:remove_const, :OPENBLAS_TGZ)
  Object.send(:remove_const, :OPENBLAS_LOG)
end
