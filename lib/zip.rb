module Zip
  def self.compress(*args)
    Miniz.zip(*args)
  end

  def self.uncompress(filezip, path = ".", application = true, clear_dir = true)
    dir = "#{path}/#{File.basename(filezip).split(".").first}" if application
    clean(dir) if clear_dir
    Miniz.unzip(filezip, path)
  end

  def self.clean(dir)
    # TODO Refactor file check
    if Dir.exist?(dir)
      files = Dir.entries(dir)
      files.each do |file|
        next if (file == ".." || file == ".")
        if File.file?("#{dir}/#{file}")
          File.delete("#{dir}/#{file}")
        else
          Dir.delete("#{dir}/#{file}")
        end
      end
      Dir.delete(dir)
    end
    Dir.mkdir(dir)
  end
end
