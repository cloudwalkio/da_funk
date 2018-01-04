
class NotificationTest < DaFunk::Test.case
  def setup
    @notification = DaFunk::Notification.new(15, 10)
  end

  def test_interval_last_check_blank
    assert @notification.valid_check_interval?
  end

  def test_interval_expired
    @notification.instance_eval { @last_check = (Time.now - 11) }
    assert @notification.valid_check_interval?
  end

  def test_interval_not_expired
    @notification.instance_eval { @last_check = Time.now }
    assert_equal false, @notification.valid_check_interval?
  end
end

