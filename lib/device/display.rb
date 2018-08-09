class Device
  class Display
    MAIN_BMP = "main.bmp"

    def self.adapter
      Device.adapter::Display
    end

    # Display buffer
    #
    # @param buf [String] Text to be printed.
    # @param row [Fixnum] Row to start display.
    # @param column [Fixnum] Column to start display.
    # @return [NilClass] nil.
    def self.print(buf, row = nil, column = nil)
      if row.nil? && column.nil?
        STDOUT.print(buf)
      else
        adapter.print_in_line(buf, row, column)
      end
    end

    def self.print_line(buf, row = 0, column = 0)
      self.print(buf, row, column)
    end

    # Display bitmap
    #
    # @param path [String] path
    # @param row [Fixnum] Row to start display.
    # @param column [Fixnum] Column to start display.
    # @return [NilClass] nil.
    def self.print_bitmap(path, row = 0, column = 0)
      if File.exists?(path)
        adapter.display_bitmap(path, row, column)
      else
        false
      end
    end

    # Clean display
    #
    # @param line [Fixnum] Line to clear
    def self.clear(line = nil)
      if line.nil?
        STDOUT.fresh
        adapter.clear
      else
        adapter.clear_line line
      end
    end

    # Print image in slot of status bar
    #
    # @param slot [Fixnum] Status bar slot.
    # @param image_path [String] Path to image, or send nil to clear the slot.
    # @return [NilClass] Failure.
    # @return [TrueClass] Success.
    def self.print_status_bar(slot, image_path)
      slots = self.adapter.status_bar_slots_available - 1
      if (0..slots).include?(slot)
        if image_path.nil? || File.exists?(image_path)
          self.adapter.print_status_bar(slot, image_path)
        end
      end
    end

    def self.print_main_image
      bmp = "./shared/#{self.main_image}"
      self.print_bitmap(bmp,0,0) if File.exists?(bmp)
    end

    def self.main_image
      if adapter.respond_to?(:main_image) &&
        File.exists?("./shared/#{adapter.main_image}")
        adapter.main_image
      else
        MAIN_BMP
      end
    end
  end
end

