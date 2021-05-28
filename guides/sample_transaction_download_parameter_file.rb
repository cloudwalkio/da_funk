module Guide
  def test_transaction_download_parameter_file
    tcp = test_sample_walk_socket
    if Device::Transaction::Download.request_param_file
      file = FileDb.open("params.dat")
      puts file.keys
      file.apps_list
    end
  end

  def test_transaction_download_and_parse_parameter_file
    apps = test_transaction_download_parameter_file
    apps.split(";").each do |line|
      app = line.split(",")
      puts "Name: #{app[0]}, Ruby File: #{app[1]} Aparece no menu: #{app[2]} CRC: #{app[3]}"
    end
  end
end
