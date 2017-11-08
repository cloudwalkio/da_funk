#!/usr/bin/env rake

require 'rake/testtask'
require 'bundler/setup'

Bundler.require(:default)
DA_FUNK_ROOT = File.dirname(File.expand_path(__FILE__))

FileUtils.cd DA_FUNK_ROOT

FILES = FileList[
  "lib/ext/kernel.rb",
  "lib/ext/nil.rb",
  "lib/ext/string.rb",
  "lib/ext/array.rb",
  "lib/ext/hash.rb",
  "lib/ext/float.rb",
  "lib/device/version.rb",
  "lib/da_funk/version.rb",
  "lib/da_funk/helper.rb",
  "lib/da_funk.rb",
  "lib/da_funk/test.rb",
  "lib/da_funk/screen.rb",
  "lib/da_funk/callback_flow.rb",
  "lib/da_funk/screen_flow.rb",
  "lib/da_funk/i18n_error.rb",
  "lib/da_funk/i18n.rb",
  "lib/da_funk/file_parameter.rb",
  "lib/da_funk/helper/status_bar.rb",
  "lib/da_funk/event_listener.rb",
  "lib/da_funk/event_handler.rb",
  "lib/da_funk/engine.rb",
  "lib/da_funk/struct.rb",
  "lib/device.rb",
  "lib/device/audio.rb",
  "lib/device/crypto.rb",
  "lib/device/display.rb",
  "lib/device/helper.rb",
  "lib/device/io.rb",
  "lib/device/network.rb",
  "lib/device/params_dat.rb",
  "lib/device/printer.rb",
  "lib/device/runtime.rb",
  "lib/device/setting.rb",
  "lib/device/support.rb",
  "lib/device/system.rb",
  "lib/device/transaction/download.rb",
  "lib/device/transaction/emv.rb",
  "lib/file_db.rb",
  "lib/iso8583/bitmap.rb",
  "lib/iso8583/codec.rb",
  "lib/iso8583/exception.rb",
  "lib/iso8583/field.rb",
  "lib/iso8583/fields.rb",
  "lib/iso8583/message.rb",
  "lib/iso8583/util.rb",
  "lib/iso8583/version.rb",
  "lib/iso8583/file_parser.rb",
  "lib/device/transaction/iso.rb",
  "lib/serfx.rb",
  "lib/serfx/commands.rb",
  "lib/serfx/connection.rb",
  "lib/serfx/response.rb",
  "lib/serfx/exceptions.rb",
  "lib/device/notification_event.rb",
  "lib/device/notification_callback.rb",
  "lib/device/notification.rb",
  "lib/device/application.rb",
  "lib/zip.rb",
  "lib/device/magnetic.rb"
]

DaFunk::RakeTask.new do |t|
  t.main_out  = "./out/da_funk.mrb"
  t.libs = FILES
end

desc "Generate YARD Documentation"
task :yard do
  Bundler.require(:default, :development)
  sh "yard"
end

task "test:all"         => :build
task "test:unit"        => :build
task "test:integration" => :build
