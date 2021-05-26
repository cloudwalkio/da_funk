module Guide
  # Sample Socket
  # Create socket, same syntax as default ruby standard library
  def test_sample_socket
    # Call test_sample_network to attach on GPRS
    test_sample_network_attach

    # Create TCPSocket
    tcp = TCPSocket.new('cloudwalk.io', 80)
    # print TCPSocket object
    puts tcp.inspect

    # Send and Recv some data
    puts tcp.send('303132', 0)
    puts "Recv #{tcp.recv(10)} "
    puts "Closed? #{tcp.closed?}"
    puts "Close #{tcp.close} "
    puts "Closed? #{tcp.closed?}"
  end

  def test_sample_walk_socket
    # Call test_sample_network to attach on GPRS
    test_sample_network_attach

    # Specific Walk Socket to transact in CloudWalk structure
    Device::Network.walk_socket
  end
end

