module Guide
  def test_sample_transaction_download_application
    tcp = test_sample_walk_socket
    if Device::Transaction::Download.request_file("show.rb", "show.mrb")
      load "show.mrb"
    end
  end
end

