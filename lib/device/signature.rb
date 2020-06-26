# frozen_string_literal: true

class Device
  class Signature
    FILE = './shared/device.sig'

    CONVERTED      = 1
    FILE_NOT_FOUND = 2
    IS_THE_SAME    = 3

    def self.convert
      load
      return FILE_NOT_FOUND unless @file

      if must_convert?
        @file.update_attributes({ 'signer' => DaFunk::ParamsDat.file['signer'] })
        return CONVERTED
      end
      IS_THE_SAME
    end

    def self.must_convert?
      DaFunk::ParamsDat.file['signer'] && DaFunk::ParamsDat.file['signer'] != @file['signer']
    end

    def self.load
      @file = FileDb.new FILE
    end
  end
end
