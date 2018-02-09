#!/usr/bin/env rake

require 'rake/testtask'
require 'bundler/setup'

Bundler.require(:default)
DA_FUNK_ROOT = File.dirname(File.expand_path(__FILE__))

FileUtils.cd DA_FUNK_ROOT

FILES = FileList[
  "lib/file_db.rb",
  "lib/zip.rb",
  "lib/da_funk/helper.rb",

  "lib/ext/kernel.rb",
  "lib/ext/nil.rb",
  "lib/ext/string.rb",
  "lib/ext/array.rb",
  "lib/ext/hash.rb",
  "lib/ext/float.rb",

  "lib/iso8583/bitmap.rb",
  "lib/iso8583/codec.rb",
  "lib/iso8583/exception.rb",
  "lib/iso8583/field.rb",
  "lib/iso8583/fields.rb",
  "lib/iso8583/message.rb",
  "lib/iso8583/util.rb",
  "lib/iso8583/version.rb",
  "lib/iso8583/file_parser.rb",

  "lib/device/version.rb",
  "lib/da_funk/version.rb",

  "lib/da_funk.rb",
  "lib/da_funk/payment_channel.rb",
  "lib/da_funk/connection_management.rb",
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

  "lib/da_funk/params_dat.rb",
  "lib/da_funk/application.rb",
  "lib/da_funk/transaction/iso.rb",
  "lib/da_funk/transaction/download.rb",
  "lib/da_funk/notification_event.rb",
  "lib/da_funk/notification_callback.rb",
  "lib/da_funk/notification.rb",

  "lib/device.rb",
  "lib/device/audio.rb",
  "lib/device/crypto.rb",
  "lib/device/display.rb",
  "lib/device/io.rb",
  "lib/device/network.rb",
  "lib/device/printer.rb",
  "lib/device/runtime.rb",
  "lib/device/setting.rb",
  "lib/device/support.rb",
  "lib/device/system.rb",
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
