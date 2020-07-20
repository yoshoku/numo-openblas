# frozen-string-literal: true

require 'rubygems'
require 'rubygems/package'

require 'etc'
require 'fileutils'
require 'open-uri'
require 'open3'

Gem.post_install do
  openblas_ver = '0.3.10'
  openblas_uri = "https://github.com/xianyi/OpenBLAS/archive/v#{openblas_ver}.tar.gz"
  openblas_dir = File.expand_path(__dir__ + '/../vendor')

  next true if File.exist?("#{openblas_dir}/installed_#{openblas_ver}")

  puts "Downloading OpenBLAS #{openblas_ver}."
  URI.open(openblas_uri) do |rf|
    File.open("#{openblas_dir}/tmp/openblas.tgz", 'wb') { |sf| sf.write(rf.read) }
  end

  puts 'Unpacking OpenBLAS tar.gz file.'
  Gem::Package::TarReader.new(Zlib::GzipReader.open("#{openblas_dir}/tmp/openblas.tgz")) do |tar|
    tar.each do |entry|
      next unless entry.file?

      filename = "#{openblas_dir}/tmp/#{entry.full_name}"
      next if filename == File.dirname(filename)

      FileUtils.mkdir_p("#{openblas_dir}/tmp/#{File.dirname(entry.full_name)}")
      File.open(filename, 'wb') { |f| f.write(entry.read) }
      File.chmod(entry.header.mode, filename)
    end
  end

  Dir.chdir("#{openblas_dir}/tmp/OpenBLAS-#{openblas_ver}") do
    puts 'Building OpenBLAS. This could take a while...'
    mkstdout, _mkstderr, mkstatus = Open3.capture3("make -j#{Etc.nprocessors}")
    File.open("#{openblas_dir}/tmp/openblas.log", 'w') { |f| f.puts(mkstdout) }
    unless mkstatus.success?
      puts 'Failed to build OpenBLAS.'
      puts 'Check the make-openblas.log file for more details:'
      puts "#{openblas_dir}/tmp/openblas.log"
      break false
    end

    puts 'Installing OpenBLAS.'
    insstdout, _insstderr, insstatus = Open3.capture3("make install PREFIX=#{openblas_dir}")
    File.open("#{openblas_dir}/tmp/openblas.log", 'a') { |f| f.puts(insstdout) }
    unless insstatus.success?
      puts 'Failed to install OpenBLAS.'
      puts 'Check the make-openblas.log file for more details:'
      puts "#{openblas_dir}/tmp/openblas.log"
      break false
    end

    FileUtils.touch("#{openblas_dir}/installed_#{openblas_ver}")
    true
  end
end
