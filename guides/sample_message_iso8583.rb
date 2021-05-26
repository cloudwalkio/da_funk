module Guide
  def test_message_iso
    message = Device::Transaction::Iso.new
    message.mti = 1110

    message[2] = 474747474747
    message["Processing Code"] = "123456"
    pan = message["Primary Account Number (PAN)"]

    puts message.pan
    puts message.to_b
    puts message.to_s
  end
end
