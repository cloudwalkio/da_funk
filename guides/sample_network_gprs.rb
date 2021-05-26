module Guide
  # Sample Device::Network
  # Attach on GPRS
  def test_sample_network_attach
    # Initialize hardware with configurations
    Device::Network.init(:gprs, apn: 'claro.com.br', user: 'claro.com.br', pass: 'claro.com.br')
    # Start Attaching process
    Device::Network.connect

    # Attaching process is unblocking, for this sample let's wait until return something
    iRet = 1
    while(iRet == 1)
      iRet = Device::Network.connected?
    end
  end

  def test_sample_network_ping
    test_sample_network_attach
    Device::Network.ping("cloudwalk.io", 8000)
  end

  def test_sample_network_disconnect
    test_sample_network_attach
    puts "Disconnect #{Device::Network.disconnect}"
  end
end
