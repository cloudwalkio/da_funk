module DaFunk
  class SecureRandom
    def self.random_bytes(n = nil)
      n = n ? n.to_int * 2 : 16 * 2
      chars = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
      string = (0...n-1).map { chars[rand(chars.length)] }.join
      string.unpack('C*').pack('C*')
    end

    def self.uuid
      bytes = random_bytes.unpack('NnnnnN')
      bytes[2] = (bytes[2] & 0x0fff) | 0x4000
      bytes[3] = (bytes[3] & 0x3fff) | 0x8000
      "%08x-%04x-%04x-%04x-%04x%08x" % bytes
    end
  end
end
