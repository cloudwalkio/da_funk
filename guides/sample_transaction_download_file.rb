module Guide
  def test_transaction_download_file
    test_sample_network_attach
    Device::Transaction::Download.request_file("remote_image_path.jpg", "local_image_path.jpg")
  end
end
