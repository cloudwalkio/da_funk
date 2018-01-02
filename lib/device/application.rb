# Scenario
# 1. Load from scratch
# - No file downloaded
# - with file downloaded
# 2. Second load
# - No crc update
# - With crc update

class Device
  class Application
    attr_accessor  :crc
    attr_reader :label, :file, :type, :order, :name, :remote, :original, :crc_local

    def self.delete(collection)
      collection.each do |app|
        begin
          app.delete
        rescue RuntimeError
        end
      end
    end

    def initialize(label, remote, type, crc)
      @type     = type
      @crc      = crc
      @original = remote
      @order, @label = split_label(label)
      company    = check_company(remote)
      @remote    = remote.sub("#{company}_", "")
      @name      = remote.sub("#{company}_", "").split(".")[0]
      @file      = check_path(@remote)
      @crc_local = @crc if File.exists?(@file)
    end

    def download(force = false)
      if force || self.outdated?
        ret = Device::Transaction::Download.request_file(remote, file, crc_local)
      else
        ret = Device::Transaction::Download::FILE_NOT_CHANGE
      end
      if ret == Device::Transaction::Download::SUCCESS
        @crc_local = calculate_crc
        if @crc_local != @crc
          return Device::Transaction::Download::COMMUNICATION_ERROR
        end
      end
      ret
    rescue => e
      ContextLog.exception(e, e.backtrace, "Error downloading #{self.name}")
      Device::Transaction::Download::IO_ERROR
    end

    def dir
      @name
    end

    def exists?
      File.exists? file
    end

    def delete
      File.delete(self.file) if exists?
      if self.ruby? && Dir.exist?(self.dir) && self.dir != "main"
        Dir.delete(self.dir)
      end
    end

    def outdated?
      return true unless File.exists?(file)
      @crc_local = calculate_crc unless @crc_local
      @crc_local != @crc
    rescue
      true
    end

    def execute(json = "")
      if posxml?
        PosxmlInterpreter.new(remote, nil, false).start
      else
        Device::Runtime.execute(name, json)
      end
    end

    def posxml?
      @type == "posxml" || remote.include?(".posxml")
    end

    def ruby?
      @type == "ruby" || (! remote.include? ".posxml")
    end

    private

    def check_company(name)
      name.split("_", 2)[0]
    end

    def calculate_crc
      if exists?
        handle = File.open(file)
        Device::Crypto.crc16_hex(handle.read)
      end
    ensure
      handle.close if handle
    end

    def check_path(path)
      if posxml?
        "./shared/#{path}"
      else
        "#{path.gsub("#{Device::Setting.company_name}_", "")}.zip"
      end
    end

    def split_label(text)
      if text == "X"
        number, text = 0, "X"
      else
        number, text = text.to_s.split(" - ")
      end

      [number.to_i, text.to_s]
    end
  end
end

