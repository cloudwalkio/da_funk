# Scenario
# 1. Load from scratch
# - No file downloaded
# - with file downloaded
# 2. Second load
# - No crc update
# - With crc update

module DaFunk
  class Application
    class ApplicationError < StandardError; end
    class FileNotFoundError < StandardError; end

    attr_accessor :crc
    attr_reader :label, :file, :type, :order, :name, :remote, :original

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
    end

    def crc_local
      self.exists? ? @crc_local : nil
    end

    def download(force = false)
      if force || self.outdated?
        ret = DaFunk::Transaction::Download.request_file(remote, file, self.crc_local)
        if ret == DaFunk::Transaction::Download::SUCCESS
          if ((@crc_local = calculate_crc) == @crc)
            unzip
          else
            ret = DaFunk::Transaction::Download::COMMUNICATION_ERROR
          end
        elsif ret == DaFunk::Transaction::Download::FILE_NOT_CHANGE
          unzip
        end
      else
        ret = DaFunk::Transaction::Download::FILE_NOT_CHANGE
      end
      ret
    rescue => e
      ContextLog.exception(e, e.backtrace, "Error downloading #{self.name}")
      DaFunk::Transaction::Download::IO_ERROR
    end

    def unzip
      if self.ruby?
        zip = self.file
        message = "Problem to unzip #{zip}[#{name}]"
        raise FileNotFoundError.new(message) unless self.exists?
        raise ApplicationError.new(message) unless Zip.uncompress(zip)
      end
    end

    def dir
      @name
    end

    def exists?
      File.exists?(file)
    end

    def delete
      File.delete(self.file) if exists?
      if self.ruby? && Dir.exist?(self.dir) && self.dir != "main"
        Zip.clean(self.dir)
      end
    end

    def outdated?(force = false)
      return true unless self.exists?
      if !self.crc_local || force
        @crc_local = calculate_crc
      end
      self.crc_local != @crc
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
        Device::Crypto.file_crc16_hex(file)
      end
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

      if number && text
        [number.to_i, text.to_s]
      else
        [0, text.to_s]
      end
    end
  end
end

