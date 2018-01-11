module DaFunk
  class FileParameter
    FILEPATH = "./shared"
    attr_accessor :crc
    attr_reader :name, :file, :original, :remote

    def self.delete(collection)
      collection.each do |file_|
        begin
          file_.delete
        rescue RuntimeError
        end
      end
    end

    def initialize(name, crc)
      @crc      = crc
      @original = name
      company   = check_company(name)
      @remote   = @original.sub("#{company}_", "")
      @name     = @original.sub("#{company}_", "").split(".").first
      @file     = "#{FILEPATH}/#{@remote}"
    end

    def crc_local
      self.exists? ? @crc_local : nil
    end

    def zip?
      @original.to_s[-4..-1] == ".zip"
    end

    def exists?
      File.exists? @file
    end

    def unzip
      if zip? && exists?
        Zip.uncompress(file, FILEPATH, false, false)
      end
    end

    def download(force = false)
      if force || self.outdated?
        ret = DaFunk::Transaction::Download.request_file(remote, file, self.crc_local)
        if ret == DaFunk::Transaction::Download::SUCCESS
          unless ((@crc_local = calculate_crc) == @crc)
            ret = DaFunk::Transaction::Download::COMMUNICATION_ERROR
          end
        end
      else
        ret = DaFunk::Transaction::Download::FILE_NOT_CHANGE
      end
      ret
    rescue => e
      ContextLog.exception(e, e.backtrace, "Error downloading #{self.name}")
      DaFunk::Transaction::Download::IO_ERROR
    end

    def delete
      File.delete(self.file) if exists?
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

    private
    def calculate_crc
      if exists?
        Device::Crypto.file_crc16_hex(file)
      end
    end

    def check_company(name)
      name.split("_", 2)[0]
    end

    def remove_company(name)
      name.split("_")[1..-1].join("_")
    end
  end
end

