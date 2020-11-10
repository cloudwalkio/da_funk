module DaFunk
  class Transaction
    class Reversal
      def self.filename
        DaFunk::ParamsDat.file['reversal_file_name'] || 'cw_reversal_transact.dat'
      end

      def self.exists?
        File.exists? "./shared/#{filename}"
      end
    end
  end
end
