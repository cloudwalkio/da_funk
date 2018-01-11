
class NotificationEventTest < DaFunk::Test.case
  def setup
    @str = '{"id":3,"event":"3|SHOW_MESSAGE|TEST1|12-20-2017 18:23","acronym":"pc1","logical_number":"5A179615"}'
    @json  = JSON.parse @str
    @event = DaFunk::NotificationEvent.new(@json["id"], @json["event"], @json["acronym"], @json["logical_number"])
  end

  def test_attr_id
    assert_equal @json["id"], @event.id
  end

  def test_attr_acronym
    assert_equal @json["acronym"], @event.acronym
  end

  def test_attr_logical_number
    assert_equal @json["logical_number"], @event.logical_number
  end

  def test_attr_parameters
    assert_equal ["TEST1", "12-20-2017 18:23"], @event.parameters
  end

  def test_attr_callback
    assert_equal "SHOW_MESSAGE", @event.callback
  end
end

