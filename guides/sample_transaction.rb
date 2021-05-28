module Guide
  def test_transaction_data
    # Open CloudWalk socket
    socket = test_sample_walk_socket

    # Send any data for registered server in that app
    socket.send("data\n")

    # Receive some data from server 
    puts "Recv Registered Server for this app: #{socket.recv(10).unpack("H*")}"

    socket.close
    Device::Network.disconnect
  end

  def test_transaction_iso8583
    # peding test sample
  end

  def test_transaction_emv
    # peding test sample
  end
end
