module DaFunk
  class ParamsDat
    FILE_NAME                   = "./main/params.dat"
    SEARCHING_IMAGE_PATH        = './shared/searching_updates_app.bmp'
    UPDATING_IMAGE_PATH         = './shared/updating.bmp'
    ATTACH_IMAGE_PATH           = './shared/network_conectar_init.bmp'
    CONNECTION_ERROR_IMAGE_PATH = './shared/network_system_error.bmp'

    include DaFunk::Helper

    class << self
      attr_accessor :file, :apps, :valid, :files, :checksum
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
      @checksum = calculate_checksum
      @file = FileDb.new(FILE_NAME)
    end

    def self.calculate_checksum
      Device::Crypto.crc16_hex(File.read(FILE_NAME)) if exists?
    end

    def self.corrupted?
      return true unless exists?
      @checksum != calculate_checksum
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

      Device::Signature.convert
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
      ret          = false
      download_ret = false
      Device::Display.print_bitmap(ATTACH_IMAGE_PATH) unless enable_txt_ui
      if attach(attach_options(enable_txt_ui))
        parse
        try(3) do |attempt|
          if enable_txt_ui
            Device::Display.clear
            I18n.pt(:downloading_content, :args => ["PARAMS", 1, 1])
            getc(100)
          end
          Device::Display.print_bitmap(SEARCHING_IMAGE_PATH) unless enable_txt_ui
          download_ret = DaFunk::Transaction::Download.request_param_file(FILE_NAME)
          ret = check_download_error(download_ret, enable_txt_ui)
        end
        show_download_error(download_ret, enable_txt_ui) unless ret
        parse if ret
      else
        unless enable_txt_ui
          Device::Display.print_bitmap(CONNECTION_ERROR_IMAGE_PATH)
          getc(5000)
        end
      end
      ret
    end

    def self.update_apps(force_params = false, force_crc = false, force = false, enable_txt_ui = true)
      ret = true
      if force_params || ! self.valid
        ret = self.download(enable_txt_ui)
      end

      main_updated = nil
      if self.valid && ret
        apps_to_update = self.outdated_apps(force_crc, force)
        size_apps = apps_to_update.size
        apps_to_update.each_with_index do |app, index|
          ret = self.update_app(app, index+1, size_apps, force_crc || force, enable_txt_ui)
          main_updated ||= (ret && app.main_application?)
        end

        if ret
          files_to_update = self.outdated_files(force_crc, force)
          size_files = files_to_update.size
          files_to_update.each_with_index do |file_, index|
            ret = self.update_file(file_, index+1, size_files, force_crc || force, enable_txt_ui)
          end
        end
      end
      ret
    ensure
      self.restart if main_updated
    end

    def self.restart
      Device::Display.clear
      if File.exists?('./shared/init_reboot.bmp')
        Device::Display.print_bitmap('./shared/init_reboot.bmp')
        getc(3000)
      else
        I18n.pt(:admin_main_update_message)
        3.times do |i|
          Device::Display.print("REBOOTING IN #{3 - i}",3,3)
          sleep(1)
        end
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
      ret          = false
      download_ret = false
      Device::Display.print_bitmap(ATTACH_IMAGE_PATH) unless enable_txt_ui
      if attach(attach_options(enable_txt_ui)) && application
        try(3) do |attempt|
          if enable_txt_ui
            Device::Display.clear
            I18n.pt(:downloading_content, :args => [I18n.t(:apps), index, all])
            getc(100)
          end
          Device::Display.print_bitmap(UPDATING_IMAGE_PATH) unless enable_txt_ui
          download_ret = application.download(force)
          ret = check_download_error(download_ret, enable_txt_ui)
        end
        show_download_error(download_ret, enable_txt_ui) unless ret
      else
        unless enable_txt_ui
          Device::Display.print_bitmap(CONNECTION_ERROR_IMAGE_PATH)
          getc(5000)
        end
      end
      ret
    end

    def self.update_file(file_parameter, index = 1, all = 1, force = false, enable_txt_ui = true)
      ret          = false
      download_ret = false
      Device::Display.print_bitmap(ATTACH_IMAGE_PATH) unless enable_txt_ui
      if attach(attach_options(enable_txt_ui)) && file_parameter
        try(3) do |attempt|
          if enable_txt_ui
            Device::Display.clear
            I18n.pt(:downloading_content, :args => [I18n.t(:files), index, all])
            getc(100)
          end
          Device::Display.print_bitmap(UPDATING_IMAGE_PATH) unless enable_txt_ui
          download_ret = file_parameter.download(force)
          ret = check_download_error(download_ret, enable_txt_ui)
          if ret
            file_parameter.unzip
            getc(1000)
          end
          ret
        end
        show_download_error(download_ret, enable_txt_ui) unless ret
      else
        unless enable_txt_ui
          Device::Display.print_bitmap(CONNECTION_ERROR_IMAGE_PATH)
          getc(5000)
        end
      end
      ret
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
