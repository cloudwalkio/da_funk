module DaFunk
  module Helper
    def self.included(base)
      base.extend self
    end

    def form(label, options = {})
      Device::Display.clear
      options = form_default(options)
      options[:value] ||= options.delete(:default)
      puts "#{label}:"
      string = get_format(options.delete(:min), options.delete(:max), options)
      return options[:value] if string == Device::IO::CANCEL || string == Device::IO::KEY_TIMEOUT
      string
    end

    # {
    #   :bmps => {
    #     :attach_connecting => "<path>",
    #     :attach_connected => "<path>",
    #     :attach_fail => "<path>",
    #     :attach_loop => ["<path1>", "<path2>", "<path3>", "<path4>"],
    #   }
    # }
    #
    # {:print_last => true} || nil

    def attach(options = {:print_last => true})
      if Device::Network.configured?
        print_attach(:attach_connecting, options)
        unless Device::Network.connected?
          if Device::Network.attach(options) == Device::Network::SUCCESS
            Device::Setting.network_configured = 1
            print_attach(:attach_connected, options)
          else
            Device::Setting.network_configured = 0 if DaFunk::ParamsDat.file["connection_management"] == "0"
            print_attach(:attach_fail, options.merge(:args => [Device::Network.code.to_s]))
            getc(4000)
            return false
          end
        else
          print_attach(:attach_already_connected, options)
        end
        true
      else
        print_attach(:attach_device_not_configured, options)
        getc(2000)
        false
      end
    end

    def check_download_error(ret)
      value = true
      case ret
      when DaFunk::Transaction::Download::SERIAL_NUMBER_NOT_FOUND
        I18n.pt(:download_serial_number_not_found, :args => [ret])
        value =  false
      when DaFunk::Transaction::Download::FILE_NOT_FOUND
        I18n.pt(:download_file_not_found, :args => [ret])
        value = false
      when DaFunk::Transaction::Download::FILE_NOT_CHANGE
        I18n.pt(:download_file_is_the_same, :args => [ret])
      when DaFunk::Transaction::Download::SUCCESS
        I18n.pt(:download_success, :args => [ret])
      when DaFunk::Transaction::Download::COMMUNICATION_ERROR
        I18n.pt(:download_communication_failure, :args => [ret])
        value = false
      when DaFunk::Transaction::Download::MAPREDUCE_RESPONSE_ERROR
        I18n.pt(:download_encoding_error, :args => [ret])
        value = false
      when DaFunk::Transaction::Download::IO_ERROR
        I18n.pt(:download_io_error, :args => [ret])
        value = false
      else
        I18n.pt(:download_communication_failure, :args => [ret])
        value = false
      end

      value
    end

    def try(tries, &block)
      tried = 0
      ret = false
      while (tried < tries && ! ret)
        ret = block.call(tried)
        tried += 1
      end
      ret
    end

    def try_key(keys, timeout = Device::IO.timeout)
      key = nil
      keys = [keys].flatten
      time = Time.now + timeout / 1000 if (timeout != 0)
      while (! keys.include?(key)) do
        return Device::IO::KEY_TIMEOUT if (timeout != 0 && time < Time.now)
        key = getc(timeout)
      end
      key
    end

    # must send nonblock proc
    def try_user(timeout = Device::IO.timeout, options = nil, &block)
      time = timeout != 0 ? Time.now + timeout / 1000 : Time.now
      processing = Hash.new(keep: true)
      interation = 0
      while(processing[:keep] && processing[:key] != Device::IO::CANCEL) do
        if options && options[:bmps] && files = options[:bmps][:attach_loop]
          Device::Display.print_bitmap(files[interation])
          max = files.size - 1
          interation = (max >= interation) ? 0 : interation + 1
        end
        if processing[:keep] = block.call(processing)
          processing[:key] = getc(300)
        end
        break if time < Time.now
      end
      processing
    end

    # Create a form menu.
    #
    # @param title [String] Text to display on line 0. If nil title won't be
    #   displayed and Display.clear won't be called on before the option show.
    # @param selection [Hash] Hash (display text => value that will return)
    #   containing the list options.
    # @param options [Hash] Hash containing options to change the menu behaviour.
    #
    # @example
    #   options = {
    #     # default value to return if enter, you can work with complex data.
    #     :default => 10,
    #     # Add number to label or not
    #     :number => true,
    #     # Input Timeout in miliseconds
    #     :timeout => 30_000
    #   }
    #
    #   selection = {
    #     "option X" => 10,
    #     "option Y" => 11
    #   }
    #
    #   menu("Option menu", selection, options)
    #
    def menu(title, selection, options = {})
      return nil if selection.empty?
      options[:number]    = true if options[:number].nil?
      options[:timeout] ||= Device::IO.timeout
      key, selected = pagination(title, options, selection) do |collection, line_zero|
        collection.each_with_index do |value,i|
          display = value.is_a?(Array) ? value[0] : value
          if options[:number]
            Device::Display.print("#{i+1} #{display}", i+line_zero, 0)
          else
            unless display.to_s.empty?
              Device::Display.print("#{display}", i+line_zero, 0)
            end
          end
        end
      end

      if key == Device::IO::ENTER || key == Device::IO::CANCEL
        options[:default]
      else
        selected
      end
    end

    # TODO Scalone: Refactor.
    def pagination(title, options, collection, &block)
      start_line, options[:limit], options[:header] = pagination_limit(title, options)
      if collection.size > (options[:limit] - options[:header]) # minus pagination header
        key   = Device::IO.back_key
        pages = pagination_page(collection, options[:limit] - options[:header]) # minus pagination header
        page  = 1
        while(key == Device::IO.back_key || key == Device::IO.forward_key)
          Device::Display.clear
          pagination_header(title, page, pages.size, start_line, options[:default], options[:header])
          values = pages[page].to_a
          block.call(values, start_line + options[:header])
          key  = try_key(pagination_keys(values.size, true))
          page = pagination_key_page(page, key, pages.size)
        end
      else
        Device::Display.clear
        print_title(title, options[:default]) if title
        values = collection.to_a
        block.call(values, start_line)
        key = try_key(pagination_keys(collection.size, false))
      end
      result = values[key.to_i-1] if key.integer?
      if result.is_a? Array
        [key, result[1]]
      else
        [key, result]
      end
    end

    def pagination_header(title, page, pages, line, default = nil, header = nil)
      print_title(title, default) if title
      back    = Device::IO.back_key_label
      forward = Device::IO.forward_key_label
      if header >= 1
        Device::Display.print("< #{back} __ #{page}/#{pages} __ #{forward} >", line, 0)
      end
    end

    def pagination_key_page(page, key, size)
      if key == Device::IO.back_key
        page == 1 ? page : page -= 1
      elsif key == Device::IO.forward_key
        page >= size ? size : page += 1
      end
    end

    def pagination_page(values, size)
      page = 1
      i = 0
      values.group_by do |value|
        if size <= i
          page+=1; i=1
        else
          i += 1
        end
        page
      end
    end

    def pagination_keys(size, move = true)
      keys = ((1..size.to_i).to_a.map(&:to_s) + [Device::IO::ENTER, Device::IO::CLEAR, Device::IO::CANCEL])
      keys << [Device::IO.back_key, Device::IO.forward_key] if move
      keys
    end

    def pagination_limit(title, options = {})
      number = options[:limit]
      unless (start = options[:start])
        start = title.nil? ? 0 : 1 # start in next line if title
      end

      if number
        limit = number
      else
        if STDOUT.max_y > (9 + start)
          limit = 9
        else
          limit = STDOUT.max_y - start # minus title
        end
      end

      if options[:header].nil? || options[:header]
        header = 1
      else
        header = 0
      end

      footer = options[:footer] ? options[:footer] : 0

      [start, limit - footer, header]
    end

    def number_to_currency(value, options = {})
      options[:delimiter] ||= ","
      options[:precision] ||= 2
      options[:separator] ||= "."

      if value.is_a? Float
        number, unit = value.to_s.split(".")
        unit = unit.to_s
        len = number.size + unit.size
      else
        len    = value.to_s.size
        unit   = value.to_s[(len - options[:precision])..-1]
        if len <= options[:precision]
          number = ""
        else
          number = value.to_s[0..(len - (options[:precision] + 1)).abs]
        end
      end

      text = ""
      i = 0
      number.reverse.each_char do |ch|
        i += 1
        text << ch
        text << options[:delimiter] if (i % 3 == 0) && (len - unit.size) != i
      end
      [rjust(text.reverse, 1, "0"),rjust(unit, options[:precision], "0")].join options[:separator]
    end

    def ljust(string, size, new_string)
      string_plain = string.to_s
      if size > string_plain.size
        string_plain + (new_string * (size - string_plain.size))
      else
        string_plain
      end
    end

    def rjust(string, size, new_string)
      string_plain = string.to_s
      if size > string_plain.size
        (new_string * (size - string_plain.size)) + string_plain
      else
        string_plain
      end
    end

    private
    def form_default(options = {})
      options[:default] ||= ""
      options[:mode]    ||= Device::IO::IO_INPUT_ALPHA
      options[:min]     ||= 0
      options[:max]     ||= 20
      options
    end

    def pagination_bg_image(string)
      string.to_s.downcase.include?(".bmp") && (path = "./shared/#{string}") && File.file?(path) && path
    end

    def print_title(string, default)
      if path = pagination_bg_image(string)
        Device::Display.print_bitmap(path)
      else
        if default
          puts("#{string} (#{default})")
        else
          puts("#{string}")
        end
      end
    end

    def print_attach(id, options = nil)
      if options
        if bmps = options[:bmps]
          Device::Display.print_bitmap(bmps[id]) if bmps[id]
        else
          print_last(I18n.t(id, options)) if options[:print_last]
        end
      else
        print_last(I18n.t(id))
      end
    end
  end
end

