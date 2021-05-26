require_relative 'minitest_helper'

module ISO8583
  class TestMTIMessage < Message
    mti_format N, length: 4
    mti 100, "Test Authorization"

    bmp 2, "foo", ANS, length: 3

  end

  class TestNoMTIMessage < Message
    bmp 2, "foo", ANS, length: 3
  end

  class TestMessageInitialization < Minitest::Test
    def test_ignore_mti_field_set
      msg = TestNoMTIMessage.new(nil, true, ignore_mti: true)
      assert_equal true, msg.ignore_mti
    end

    def test_cant_set_mit_if_ignore_mti
      msg = TestNoMTIMessage.new(nil, true, ignore_mti: true)
      assert_raises { msg.mti = 100 }
    end

    def test_can_set_mti_unless_ignore_mti
      msg = TestMTIMessage.new(100, true)

      assert_equal 100, msg.mti
    end
  end

  class Test_to_b_Method < Minitest::Test
    def test_raises_when_no_mti_and_no_ignore_mti
      msg = TestMTIMessage.new(nil, true)
      assert_raises {msg.to_b}
    end

    def test_return_bitmap_without_mti_set
      skip
      msg = TestNoMTIMessage.new(nil, true, ignore_mti: true, bitmap_size: 24)
      msg[2] = "bar"
      assert_equal("400bar", msg.to_b)
    end
  end
end
