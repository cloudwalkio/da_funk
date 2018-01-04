
class Device
  class Transaction
    class Download
      ERL_VERSION_MAGIC        = 131
      ERL_NIL_EXT              = 'j'
      ERL_SMALL_TUPLE_EXT      = 'h'
      ERL_ATOM_EXT             = 'd'
      ERL_BINARY_EXT           = 'm'
      ERL_INTEGER_EXT          = 'b'
      ERL_CONTENT_TYPE         = "application/x-erlang-binary"
      MAXATOMLEN               = 255
      PARAMS_FILE              = "params.dat"

      SUCCESS                  = 0
      FILE_NOT_CHANGE          = 1
      FILE_NOT_FOUND           = 2
      SERIAL_NUMBER_NOT_FOUND  = 3
      COMMUNICATION_ERROR      = -1
      MAPREDUCE_RESPONSE_ERROR = -2
      IO_ERROR                 = -3

      def self.check(ret)
        case ret
        when SERIAL_NUMBER_NOT_FOUND
        when FILE_NOT_FOUND
        when FILE_NOT_CHANGE
          return true
        when SUCCESS
          return true
        when COMMUNICATION_ERROR
        when MAPREDUCE_RESPONSE_ERROR
        when IO_ERROR
        end
        false
      end

      def self.request_file(remote_path, local_path, crc = nil)
        download = Device::Transaction::Download.new(Device::System.serial, "", DaFunk::VERSION)
        download.perform(Device::Network.socket,
                         Device::Setting.company_name,
                         remote_path, local_path, Device::System.app,
                         Device::Setting.logical_number, crc)
      end

      def self.request_param_file(file = PARAMS_FILE)
        request_file("#{Device::Setting.logical_number}_#{PARAMS_FILE}", file)
      end

      attr_accessor :buffer, :request, :first_packet, :socket, :path, :crc

      def initialize(serial, path, version)
        @serial  = serial
        @path    = path
        @version = version
      end

      #  0: Success
      # -1: Commnucation error
      # -2: Mapreduce response error
      # -3: IO Error
      def perform(socket_proc, company_name, remote_path, filepath, current_app, logical_number, file_crc = nil, socket_call = true)
        if socket_call
          @socket, @buffer, @request, @first_packet = socket_proc.call, "", "", ""
        else
          @socket, @buffer, @request, @first_packet = socket_proc, "", "", ""
        end
        @crc = file_crc ? file_crc : generate_crc(filepath)
        key = "#{company_name}_#{remote_path}"

        ei_encode_version                # version
        ei_encode_list_header(3)         # mapreduce with 3 tuples
        ei_encode_tuple_header(2)        # tuple 1 inputs
        ei_encode_atom("inputs")         # atom inputs
        ei_encode_list_header(1)         # list inputs
        ei_encode_tuple_header(2)        # tuple contendo 2 elementos binarios, bucket and key
        ei_encode_binary("assets")       # elemento binario bucket
        ei_encode_binary(key)            # elemento binario key
        ei_encode_list_header(0)         # fim da list do inputs

        ei_encode_tuple_header(2)        # tuple 2: query
        ei_encode_atom("query")          # atom query
        ei_encode_list_header(1)         # list da query
        ei_encode_tuple_header(4)        # tuple contendo 4 elementos, { map, {modfun,Module,Function}, args, true }
        ei_encode_atom("map")            # primeiro elemento, atom type
        ei_encode_tuple_header(3)        # segundo elemento, nova tuple contendo 3 atoms
        ei_encode_atom("modfun")         # primeiro atom do segundo elemento, modfun
        ei_encode_atom("walk")           # segundo atom do segundo elemento, Module
        ei_encode_atom("get_asset")      # terceiro atom do segundo elemento, Function

        ei_encode_list_header(7)         # terceiro elemento, uma list com parametros do walk
        ei_encode_binary(@serial)        # elemento binario serialterminal
        ei_encode_binary(@version)       # elemento binario versao walk
        ei_encode_binary(remote_path)      # elemento binario nomeaplicativo
        ei_encode_binary(@crc)            # elemento binario crc aplicativo
        ei_encode_binary("")             # elemento binario buffer do posxml
        ei_encode_binary(logical_number) # elemento binario numero do terminal
        ei_encode_binary(current_app)    # elemento binario nome do aplicativo que esta sendo executado
        ei_encode_list_header(0)         # fim da list com parametros do walk

        ei_encode_atom("true")           # quarto elemento, atom true
        ei_encode_list_header(0)         # fim da list da query

        ei_encode_tuple_header(2)        # tuple 3: timeout
        ei_encode_atom("timeout")        # atom timeout
        ei_encode_long(5000)             # integer timeout
        ei_encode_list_header(0)         # fim da list do mapreduce contendo 3 tuples

        mount_request                    # add request to protocol buffers message

        return COMMUNICATION_ERROR unless @socket

        # Send Request
        socket.write(@request)

        return COMMUNICATION_ERROR if (response_size = get_response_size(read_header_size(socket))) <= 0

        return MAPREDUCE_RESPONSE_ERROR unless @first_packet = get_binary_term_beginning(response_size)

        return_code = @first_packet[7].to_s.unpack("C*").first
        file_size   = @first_packet[9..12].to_s.unpack("N*").first

        if return_code != FILE_NOT_CHANGE
          return IO_ERROR if (partial_download_to_store(filepath, response_size, file_size) < 0)
        end

        # receive 6A
        @socket.read(1) if response_size > 1024
        if socket_call
          @socket.close unless @socket.closed?
        end

        return_code
      rescue SocketError
        return COMMUNICATION_ERROR
      rescue => e
        ContextLog.exception(e, e.backtrace)
        return IO_ERROR
      end

      def generate_crc(local_path)
        if File.exists?(local_path)
          file = File.open(local_path)
          Device::Crypto.crc16_hex(file.read)
        else
          ""
        end
      ensure
        file.close if file
      end

      private

      def read_header_size(socket)
        buf, error = socket_read(socket, 4, Device::Setting.tcp_recv_timeout.to_i, 0)
        case error
        when nil
          buf
        else
          ""
        end
      end

      def socket_read(socket, size, timeout_seconds, total_attempts)
        total_buffer = ""
        error = nil
        attempts = 0
        timeout = Time.now + timeout_seconds
        loop do
          buf = socket.recv_nonblock(size - total_buffer.size)
          total_buffer << buf.to_s
          break if total_buffer.size >= size
          break(error = :socket_closed) if buf.nil?
          if (Time.now > timeout)
            attempts+=1
            timeout = Time.now + timeout_seconds
            break(error = :attempts_exceeded) if attempts > total_attempts
          end
          break(error = :user_cancel) if (getc(200) == Device::IO::CANCEL)
        end
        [total_buffer, error]
      end

      def get_response_size(bytes)
        return -1 if bytes.to_s.size <= 0
        bytes.to_s.unpack("N*").first
      end

      def get_binary_term_beginning(response_size)
        if response_size > 1024
          packet = socket.read(1024)
        else
          packet = socket.read(response_size)
        end

        if packet.include?("\x83\x6c\x00")
          "\x83\x6c\x00#{packet.split("\x83\x6C\x00")[1]}"
        else
          return false
        end
      end

      def makelong(a, b)
        (a & 0xffff) | ((b & 0xffff) << 16)
      end

      def makeword(a, b)
        (a & 0xff) | ((b & 0xff) << 8)
      end

      def partial_download_to_store(filepath, response_size, file_size)
        tmp  = tmp_file(filepath)
        file = File.open(tmp, "w+")

        if (response_size > 1024)
          file.write(@first_packet[13..-1])
          downloaded = 1024
          while(downloaded < (response_size - 1))

            if (to_download = response_size - downloaded) > 1024
              to_download = 1024
            else
              to_download -= 1 # because of 6A
            end

            downloaded += file.write(socket.read(to_download))
          end
        else
          # -2 because of 6A
          downloaded = file.write(@first_packet[13..-2])
        end

        file.close
        File.rename(tmp, filepath)
        downloaded
      end

      def put(value)
        @buffer << value
      end

      def put8(value)
        @buffer << value
      end

      def put32be(value)
        @buffer << [value].pack("N")
      end

      def put16be(value)
        @buffer << [value].pack("n")
      end

      def ei_encode_version
        put8(ERL_VERSION_MAGIC.chr)
      end

      def ei_encode_list_header(arity)
        put8(ERL_NIL_EXT)
        put32be(arity) if arity > 0
      end

      def ei_encode_tuple_header(arity)
        # if (arity <= 0xff) ERL_SMALL_TUPLE_EXT else ERL_LARGE_TUPLE_EXT
        put8(ERL_SMALL_TUPLE_EXT)
        put8(arity.chr);
      end

      # TODO: Check why MAXATOMLEN
      def ei_encode_atom(value)
        value.size > MAXATOMLEN ? len = MAXATOMLEN : len = value.size
        put8(ERL_ATOM_EXT)
        put16be(len)
        put(value)
      end

      def ei_encode_binary(value)
        put8(ERL_BINARY_EXT)

        # TODO: Check it after to implement on put.
        if value.is_a? Fixnum
          put32be(2)
          @buffer << [value].pack("s")
        else
          put32be(value.size)
          put(value)
        end
      end

      def ei_encode_long(value)
        put8(ERL_INTEGER_EXT)
        put32be(value)
      end

      def mount_request
        request_size   = [@buffer.size].pack("s") + "\x01"

        put8("\x12")
        put8("\x1b")
        new_request = [@request.size].pack("N")
        new_request << "\x17"
        new_request << "\x0A"
        new_request << "#{request_size}#{@buffer}#{ERL_CONTENT_TYPE}"
        new_request << @request
        @request = new_request
      end

      # MRuby do not support String#ljust
      # TODO: duplicated from lib/variable.rb
      def ljust(size, string)
        if size > string.size
          string = string + ("\x00" * (size - string.size))
        end
        string
      end

      def tmp_file(path)
        paths = path.split("/")
        paths[-1] = "tmp_#{paths.last}"
        paths.join("/")
      end
    end
  end
end

