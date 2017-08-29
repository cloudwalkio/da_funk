#!/usr/bin/env rake

require 'rake'
require 'rake/tasklib'
require 'fileutils'
require 'bundler/setup'

module DaFunk
  class RakeTask < ::Rake::TaskLib
    include ::Rake::DSL if defined?(::Rake::DSL)

    attr_accessor :name, :libs, :tests, :tests_unit, :tests_integration, :root_path, :main_out,
      :test_out, :resources, :mrbc, :mruby, :out_path, :resources_out, :debug,
      :tests_resources, :tests_res_out

    def initialize
      yield self if block_given?

      @debug               = @debug.is_a?(FalseClass) ? false : true
      @libs              ||= FileList['lib/**/*.rb']
      @tests             ||= FileList['test/**/*test.rb']
      @tests_integration ||= FileList['test/integration/**/*test.rb']
      @tests_unit        ||= FileList['test/unit/**/*test.rb']
      @tests_resources   ||= FileList['test/resources/**/*']
      @root_path         ||= "./"
      @name              ||= File.basename(File.expand_path(@root_path))
      @out_path          ||= File.join(root_path, "out", @name)
      @main_out          ||= File.join(out_path, "main.mrb")
      @test_out          ||= File.join(out_path, "test.mrb")
      @resources         ||= FileList['resources/**/*']
      @resources_out     ||= @resources.pathmap("%{resources,#{File.join(root_path, "out")}}p")
      @tests_res_out     ||= @tests_resources.pathmap("%{test/resources,out}p")
      @mruby             ||= "cloudwalk run"
      @mrbc              = get_mrbc_bin(@mrbc)

      define
    end

    def debug_flag
      if @debug
        "-g"
      else
        ""
      end
    end

    def get_mrbc_bin(from_user)
      if (! system("type mrbc > /dev/null 2>&1 ")) && from_user
        from_user
      elsif system("type mrbc > /dev/null 2>&1 ")
        "env mrbc"
      elsif ENV["MRBC"]
        ENV["MRBC"]
      elsif system("type cloudwalk > /dev/null 2>&1 ")
        "env cloudwalk compile"
      else
        puts "$MRBC isn't set or mrbc/cloudwalk isn't on $PATH"
        exit 0
      end
    end

    def execute_tests(files)
      # Debug is always on during tests(-g)
      command_line     = File.join(File.dirname(__FILE__), "..", "..", "utils", "command_line_platform.rb")
      command_line_obj = File.join(root_path, "out", "main", "command_line_platform.mrb")
      all_files        = FileList["test/test_helper.rb"] + libs + files + [command_line] + [File.join(File.dirname(__FILE__), "..", "..", "utils", "test_run.rb")]
      if platform_call("#{mrbc} -g -o #{command_line_obj} #{command_line}") && platform_call("#{mrbc} -g -o #{test_out} #{all_files.uniq}")
        puts "cd #{File.dirname(out_path)}"
        FileUtils.cd File.dirname(out_path)
        platform_call("#{mruby} #{File.join(name, "test.mrb")}")
      end
    end

    def check_gem_out(gem)
      if File.exists?(path = File.join(gem.full_gem_path, "out", "#{gem.name}.mrb")) && File.file?(path)
      elsif File.exists?(path = File.join(gem.full_gem_path, "out", gem.name, "main.mrb")) && File.file?(path)
      elsif File.exists?(path = File.join(gem.full_gem_path, "out", gem.name, "#{gem.name}.mrb")) && File.file?(path)
      else
        return nil
      end
      return path
    end

    def platform_call(command)
      if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM)
        sh("bash -c \"#{command}\"")
      else
        sh command
      end
    end

    def define
      task :resources do
        FileUtils.rm_rf File.join(root_path, "out")
        FileUtils.mkdir_p out_path
        FileUtils.mkdir_p File.join(root_path, "out", "main")
        FileUtils.mkdir_p File.join(root_path, "out", "shared")

        resources.each_with_index do |file,dest_i|
          FileUtils.cp(file, resources_out[dest_i]) if File.file?(file)
        end

        Bundler.load.specs.each do |gem|
          path = check_gem_out(gem)
          FileUtils.cp(path, File.join(out_path, "#{gem.name}.mrb")) if path
        end
      end

      desc "Compile app to mrb and process resources"
      task :build => :resources do
        platform_call "#{mrbc} #{debug_flag} -o #{main_out} #{libs} "
      end

      desc "Compile, build and pack app and resources"
      task :package => :build do
        require "archive/zip"
        Archive::Zip.archive File.join(root_path, "out", "#{name}.zip"), File.join(out_path, ".")
      end

      namespace :test do
        task :setup => :resources do
          ENV["RUBY_PLATFORM"] = "mruby"
          tests_resources.each_with_index do |file,dest_i|
            FileUtils.cp(file, tests_res_out[dest_i]) if File.file?(file)
          end
        end

        desc "Run unit test on mruby"
        task :unit => "test:setup" do
          execute_tests(tests_unit)
        end

        desc "Run integration test on mruby"
        task :integration => "test:setup" do
          execute_tests(tests_integration)
        end

        desc "Run all test on mruby"
        task :all => "test:setup" do
          if ARGV[1]
            execute_tests(FileList[ARGV[1]])
          else
            execute_tests(tests)
          end
        end
      end

      desc "Clobber/Clean"
      task :clean do
        FileUtils.mkdir_p File.join(root_path, "out")
        FileUtils.rm_rf main_out
      end

      task :default => :build
      task :test => "test:all"
    end
  end
end
