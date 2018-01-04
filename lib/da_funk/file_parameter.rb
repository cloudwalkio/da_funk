module DaFunk
  class FileParameter
    FILEPATH = "./shared"
    attr_accessor :crc
    attr_reader :name, :file, :crc_local, :original, :remote

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
      @crc_local = @crc if File.exists?(@file)
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
      if force || outdated?
        ret = DaFunk::Transaction::Download.request_file(remote, file, crc_local)
      else
        ret = DaFunk::Transaction::Download::FILE_NOT_CHANGE
      end
      @crc_local = @crc if ret == DaFunk::Transaction::Download::SUCCESS
      ret
    end

    def delete
      File.delete(self.file) if exists?
    end

    def outdated?(force = false)
      return true unless exists?
      if !@crc_local || force
        handle = File.open(file)
        @crc_local = Device::Crypto.crc16_hex(handle.read)
      end
      @crc_local != @crc
    ensure
      handle.close if handle
    end

    private
    def check_company(name)
      name.split("_", 2)[0]
    end

    def remove_company(name)
      name.split("_")[1..-1].join("_")
    end
  end
end

