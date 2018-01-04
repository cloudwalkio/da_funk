
class Device
  class Transaction
    class EMV
      class << self
        attr_accessor :status, :mk_slot, :pinpad_type, :pinpad_wk, :show_amout
      end

      attr_accessor :data, :info

      def self.open(mk_slot, pinpad_type, pinpad_wk, show_amout)
      end

      def self.close
      end

      def self.load_tables(acquirer)
      end

      def clean
        @data = {:init => {}, :process => {}, :finish => {}}
        @info = {:init => {}, :process => {}, :finish => {}}
      end

      def init
      end

      def response
      end

      def parameters
      end

      def timeout=(seconds)
      end

      def timeout
      end

      def remove_card
      end
    end
  end
end

