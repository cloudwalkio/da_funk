
class NotificationTest < DaFunk::Test.case
  def test_notification
    Device::Setting.company_name = "pc1"
    DaFunk::Notification.setup
    notification = DaFunk::Notification.new

    assert_equal nil, notification.check
    notification.check
    notification.check
    assert notification.close
    assert notification.closed?
    notification = DaFunk::Notification.new
    assert_equal nil, notification.check
    notification.check
    notification.check
    notification.close
    assert notification.closed?
  end

  def test_notification_SHOW_MESSAGE
    $status = nil
    Device::Setting.company_name = "pc1"
    DaFunk::Notification.setup
    DaFunk::NotificationCallback.new "SHOW_MESSAGE", :on => Proc.new { |message,datetime|
      $status = message
    }

    notification = DaFunk::Notification.new

    p "Must create message AAAA"
    p "Remember to Press Enter after message appears"
    time = Time.now + 60
    while(time > Time.now && $status.nil?) do
      notification.check
      sleep 2
    end
    assert_equal "AAAA", $status

    notification.close
    assert notification.closed?
  end
end

