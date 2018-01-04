
class MrbEvalTest < DaFunk::Test.case
  def test_socket
    Device::Setting.environment = "staging"
    Device::Setting.host = Device::Setting::HOST_STAGING
    Device::Setting.company_name = "pc1"
    Device::Setting.logical_number = "1234"

    DaFunk::Notification.start
    DaFunk::Notification.check

    http = SimpleHttp.new('http', 'http://google.com', 443)
    http.socket = Device::Network.socket.call
    assert_equal 302, http.get('/').code

    command =<<EOF
    require 'da_funk'
    require 'da_funk/simplehttp'
    require '../utils/command_line_platform.rb'
    Device::Setting.environment = "staging"
    Device::Setting.host = Device::Setting::HOST_STAGING
    Device::Setting.company_name = "pc1"
    Device::Setting.logical_number = "1234"

    Device::Network.socket = nil
    http = SimpleHttp.new('http', 'http://google.com', 80)
    http.socket = Device::Network.socket.call
    response = http.get('/')
    Device::Network.socket = nil
    response.code
EOF
    command << " \n; mrb_eval(#{command.inspect})"

    assert_equal 302, mrb_eval(command)
  end
end
