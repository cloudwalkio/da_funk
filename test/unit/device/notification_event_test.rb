
class NotificationEventTest < DaFunk::Test.case
  def setup
    @stream_event = {
      "Coalesce" => true,
      "LTime" => 1792, 
      "Payload" => "{\"Body\"=>\"message 62\"}",
      "Name" => "pc1;0101",
      "Event" => "user"
    }
    @event = DaFunk::NotificationEvent.new(@stream_event)
  end

  def test_attr_coalesce
    assert_equal @stream_event["Coalesce"], @event.coalesce
  end

  def test_attr_ltim
    assert_equal @stream_event["LTime"], @event.ltime
  end

  def test_attr_payload
    assert_equal @stream_event["Payload"], @event.payload
  end

  def test_attr_name
    assert_equal @stream_event["Name"], @event.name
  end

  def test_attr_event
    assert_equal @stream_event["Event"], @event.event
  end

  def test_attr_message
    assert_equal "{\"Body\" : \"message 62\"}", @event.message
  end

  def test_attr_value
    hash = {"Body" => "message 62"}
    assert_equal hash, @event.value
  end

  def test_attr_value
    assert_equal "message 62", @event.body
  end

  def test_attr_callback
    assert_equal "message 62", @event.callback
  end

  def test_attr_callback
    assert_equal "message 62", @event.callback
  end

  def test_attr_none_parameters
    assert_equal [], @event.parameters
  end

  def test_attr_one_parameter
    stream_event = @stream_event.dup
    stream_event["Payload"].gsub!("a", "|")
    event = DaFunk::NotificationEvent.new(stream_event)
    assert_equal ["ge 62"], event.parameters
  end

  def test_attr_multiple_parameters
    stream_event = @stream_event.dup
    stream_event["Payload"].gsub!("e", "|")
    event = DaFunk::NotificationEvent.new(stream_event)
    assert_equal ["ssag", " 62"], event.parameters
  end
end

