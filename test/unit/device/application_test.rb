
class ApplicationTest < DaFunk::Test.case
  def setup
    @file_path = "#{Device::Setting.company_name}_ttt"
    @string = "12345678901234567890"
    @file = File.open("./ttt.zip", "w+")
    @file.write(@string)
    @file.close
    @crc = Device::Crypto.crc16_hex(@string)

  end

  def test_check_crc_true
    application = DaFunk::Application.new("TTT", @file_path, "ruby", nil)
    assert_equal true, application.outdated?
  end

  def test_check_crc_false
    application = DaFunk::Application.new("TTT", @file_path, "ruby", @crc)
    assert_equal false, application.outdated?
  end

  def test_check_crc_non_file
    application = DaFunk::Application.new("TTT", "./non_exists", "ruby", "1111")
    assert_equal true, application.outdated?
  end

  def teardown
    File.delete("./ttt.zip")
  end
end
