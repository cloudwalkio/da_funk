module DaFunk
  class ParamsDat
    FILE_NAME = "./main/params.dat"

    include DaFunk::Helper

    class << self
      attr_accessor :file, :apps, :valid, :files
    end

    self.apps = Array.new
    self.files = Array.new

    # To control if there is any app and parse worked
    self.valid = false

    def self.file
      self.setup unless @file
      @file
    end

    def self.setup
      @file = FileDb.new(FILE_NAME)
    end

    def self.exists?
      File.exists?(FILE_NAME)
    end

    def self.parameters_load
      return unless exists?
      apps.each {|app| return false if app.outdated? } if apps.size > 0
      files.each {|f| return false if f.outdated? } if files.size > 0
      true
    end

    def self.ready?
      self.parameters_load
    end

    def self.outdated_apps(force_crc = false, force = false)
      self.apps.select{|app| app.outdated?(force_crc) || force }
    end

    def self.outdated_files(force_crc = false, force = false)
      self.files.select{|f| f.outdated?(force_crc) || force }
    end

    def self.parse_apps
      new_apps = []
      self.file["apps_list"].to_s.gsub("\"", "").split(";").each do |app|
        label, name, type, crc = app.split(",")
        if application = get_app(name)
          application.crc = crc
        else
          application = DaFunk::Application.new(label, name, type, crc)
        end
        new_apps << application
      end
      @apps = new_apps
    end

    def self.parse_files
      new_files = []
      self.file["files_list"].to_s.gsub("\"", "").split(";").each do |f|
        name, crc = f.split(",")
        if file_ = get_file(name)
          file_.crc = crc
        else
          file_ = DaFunk::FileParameter.new(name, crc)
        end
        new_files << file_
      end
      @files = new_files
    end

    # TODO Scalone: Change after @bmsatierf change the format
    # For each apps on apps_list We'll have:
    # Today: <label>,<arquivo>,<pages>,<crc>;
    # After: <label>,<arquivo>,<type>,<crc>;
    # Today: "1 - App,pc2_app.posxml,1,E0A0;"
    # After: "1 - App,pc2_app.posxml,posxml,E0A0;"
    # After: "1 - App,pc2_app.zip,ruby,E0A0;"
    def self.parse
      return unless self.setup
      parse_apps
      parse_files

      if (@apps.size >= 1)
        self.valid = true
      else
        self.valid = false
      end
      self.valid
    end

    def self.get_app(name)
      @apps.each {|app| return app if app.original == name }
      nil
    end

    def self.get_file(name)
      @files.each {|file_| return file_ if file_.original == name}
      nil
    end

    def self.download(enable_txt_ui = true)
      if attach(attach_options(enable_txt_ui))
        parse
        ret = try(3) do |attempt|
          if enable_txt_ui
            Device::Display.clear
            I18n.pt(:downloading_content, :args => ["PARAMS", 1, 1])
          end
          getc(100)
          ret = DaFunk::Transaction::Download.request_param_file(FILE_NAME)
          unless check_download_error(ret, enable_txt_ui)
            getc(2000)
            false
          else
            true
          end
        end
        parse if ret
        ret
      end
    end

    def self.update_apps(force_params = false, force_crc = false, force = false, enable_txt_ui = true)
      self.download(enable_txt_ui) if force_params || ! self.valid
      main_updated = nil
      if self.valid
        apps_to_update = self.outdated_apps(force_crc, force)
        size_apps = apps_to_update.size
        apps_to_update.each_with_index do |app, index|
          ret = self.update_app(app, index+1, size_apps, force_crc || force, enable_txt_ui)
          main_updated ||= (ret && app.main_application?)
        end

        files_to_update = self.outdated_files(force_crc, force)
        size_files = files_to_update.size
        files_to_update.each_with_index do |file_, index|
          self.update_file(file_, index+1, size_files, force_crc || force, enable_txt_ui)
        end
      end
    ensure
      self.restart if main_updated
    end

    def self.restart
      Device::Display.clear
      I18n.pt(:admin_main_update_message)
      3.times do |i|
        Device::Display.print("REBOOTING IN #{3 - i}",3,3)
        sleep(1)
      end
      Device::System.restart
    end

    def self.format!(keep_config_files = false, keep_files = [])
      DaFunk::Application.delete(self.apps)
      DaFunk::FileParameter.delete(self.files)
      File.delete(FILE_NAME) if exists?
      @apps, @files = [], []
      Dir.entries("./shared/").each do |f|
        begin
          path = "./shared/#{f}"
          File.delete(path) if self.file_deletable?(path, keep_config_files, keep_files)
        rescue
        end
      end
    end

    def self.file_deletable?(path, keep_config_files, keep_files)
      keep = false
      if keep_config_files
        keep = [".bmp", ".jpeg", ".jpg", ".png"].find {|ext| path.include?(ext) && path.include?(Device::System.model) }
        keep ||= path.include?(Device::Display::MAIN_BMP)
        keep ||= keep_files.include?(path)
      end
      File.file?(path) && ! keep
    end

    def self.update_app(application, index = 1, all = 1, force = false, enable_txt_ui = true)
      if attach(attach_options(enable_txt_ui)) && application
        try(3) do |attempt|
          if enable_txt_ui
            Device::Display.clear
            I18n.pt(:downloading_content, :args => [I18n.t(:apps), index, all])
          end
          getc(100)
          ret = check_download_error(application.download(force), enable_txt_ui)
          getc(1000)
          ret
        end
      end
    end

    def self.update_file(file_parameter, index = 1, all = 1, force = false, enable_txt_ui = true)
      if attach(attach_options(enable_txt_ui)) && file_parameter
        try(3) do |attempt|
          if enable_txt_ui
            Device::Display.clear
            I18n.pt(:downloading_content, :args => [I18n.t(:files), index, all])
          end
          getc(100)
          ret = check_download_error(file_parameter.download(force), enable_txt_ui)
          file_parameter.unzip if ret
          getc(1000)
          ret
        end
      end
    end

    def self.apps
      self.parse unless self.valid
      @apps
    end

    def self.files
      self.parse unless self.valid
      @files
    end

    def self.executable_app
      selected = self.executable_apps
      if selected && selected.size == 1
        selected.first
      end
    end

    def self.ruby_executable_apps
      self.apps.select(&:ruby?)
    end

    def self.executable_apps
      self.apps.select{|app| app.label != "X"}
    end

    def self.application_menu
      options = Hash.new
      executable_apps.each { |app| options[app.label] = app }
      menu("Application Menu", options, {:number => true})
    end
  end
end
