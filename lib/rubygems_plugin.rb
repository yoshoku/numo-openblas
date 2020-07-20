# frozen-string-literal: true

require 'rubygems'
require 'rubygems/package'

require 'etc'
require 'fileutils'
require 'open-uri'
require 'open3'

require 'numo/openblas/version'

Gem.post_install do
  unless File.exist?("#{Numo::OpenBLAS::INSTALL_DIR}/installed_#{Numo::OpenBLAS::OPENBLAS_VERSION}")
    puts "Downloading OpenBLAS #{Numo::OpenBLAS::OPENBLAS_VERSION}."
    URI.open(Numo::OpenBLAS::OPENBLAS_URI) do |rf|
      File.open("#{Numo::OpenBLAS::INSTALL_DIR}/tmp/openblas.tgz", 'wb') { |sf| sf.write(rf.read) }
    end

    puts 'Unpacking OpenBLAS tar.gz file.'
    Gem::Package::TarReader.new(Zlib::GzipReader.open("#{Numo::OpenBLAS::INSTALL_DIR}/tmp/openblas.tgz")) do |tar|
      tar.each do |entry|
        next unless entry.file?

        filename = "#{Numo::OpenBLAS::INSTALL_DIR}/tmp/#{entry.full_name}"
        next if filename == File.dirname(filename)

        FileUtils.mkdir_p("#{Numo::OpenBLAS::INSTALL_DIR}/tmp/#{File.dirname(entry.full_name)}")
        File.open(filename, 'wb') { |f| f.write(entry.read) }
        File.chmod(entry.header.mode, filename)
      end
    end

    Dir.chdir("#{Numo::OpenBLAS::INSTALL_DIR}/tmp/OpenBLAS-#{Numo::OpenBLAS::OPENBLAS_VERSION}") do
      puts 'Building OpenBLAS. This could take a while...'
      mkstdout, _mkstderr, mkstatus = Open3.capture3("make -j#{Etc.nprocessors}")
      File.open("#{Numo::OpenBLAS::INSTALL_DIR}/tmp/openblas.log", 'w') { |f| f.puts(mkstdout) }
      unless mkstatus.success?
        puts 'Failed to build OpenBLAS.'
        puts 'Check the make-openblas.log file for more details:'
        puts "#{Numo::OpenBLAS::INSTALL_DIR}/tmp/openblas.log"
        break
      end

      puts 'Installing OpenBLAS.'
      insstdout, _insstderr, insstatus = Open3.capture3("make install PREFIX=#{Numo::OpenBLAS::INSTALL_DIR}")
      File.open("#{Numo::OpenBLAS::INSTALL_DIR}/tmp/openblas.log", 'a') { |f| f.puts(insstdout) }
      unless insstatus.success?
        puts 'Failed to install OpenBLAS.'
        puts 'Check the make-openblas.log file for more details:'
        puts "#{Numo::OpenBLAS::INSTALL_DIR}/tmp/openblas.log"
      end

      FileUtils.touch("#{Numo::OpenBLAS::INSTALL_DIR}/installed_#{Numo::OpenBLAS::OPENBLAS_VERSION}")
    end
  end
end
