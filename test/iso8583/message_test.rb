require_relative 'minitest_helper'

module ISO8583
  class TestMTIMessage < Message
    mti_format N, length: 4
    mti 100, "Test Authorization"

    bmp 2, "foo", ANS, length: 3
  end

  class TestMTIMessageBCDPacked < Message
    mti_format N_BCD, length: 4
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

    def test_set_mti_bcd_packed_bin_bitmap
      msg = TestMTIMessageBCDPacked.new(100, false)

      expected = String.new("\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00", encoding: 'ASCII-8BIT')
      assert_equal expected, msg.to_b
    end
  end

  class Test_to_b_Method < Minitest::Test
    def test_raises_when_no_mti_and_no_ignore_mti
      msg = TestMTIMessage.new(nil, true)
      assert_raises {msg.to_b}
    end

    def test_return_bitmap_without_mti_set_and_hex_bitmap
      msg = TestNoMTIMessage.new(nil, true, ignore_mti: true, bitmap_size: 24)
      msg[2] = "bar"
      assert_equal("400000bar", msg.to_b)
    end

    def test_return_bitmap_without_mti_set_and_bin_bitmap
      msg = TestNoMTIMessage.new(nil, false, ignore_mti: true, bitmap_size: 24)
      msg[2] = "bar"

      expected = String.new("\x40\x00\x00bar", encoding: 'ASCII-8BIT')
      assert_equal(expected, msg.to_b)
    end
  end

  class Test_parse_Method < Minitest::Test

    def test_parse_with_hex_bitmap
      msg = "010040bar"

      isomsg = TestMTIMessage.parse(msg, true, bitmap_size: 8)

      expected = 100
      assert_equal(expected, isomsg.mti)
      expected = "bar"
      assert_equal(expected, isomsg[2])
    end

    def test_parse_with_bin_bitmap
      msg = "0100\x40bar"

      isomsg = TestMTIMessage.parse(msg, false, bitmap_size: 8)

      expected = 100
      assert_equal(expected, isomsg.mti)
      expected = "bar"
      assert_equal(expected, isomsg[2])
    end

    def test_parse_raises_when_undefined_field
      msg = "0100\x20bar"

      e = assert_raises { TestMTIMessage.parse(msg, false, bitmap_size: 8) }
      assert_equal(ISO8583ParseException, e.class)
      assert_equal("The message contains fields not defined", e.message)
    end
  end
end
