require_relative 'minitest_helper'

module ISO8583
  class TestBitmap < Minitest::Test
    def test_parse_with_hex_bitmap_without_additional_bitmap
      message = "7020000000008000165432123456789876000000000000001500986"
      hex_bitmap = true
      bitmap_size = 64

      bitmap, _ = Bitmap.parse(message, hex_bitmap, bitmap_size)

      expect = "7020000000008000"
      assert_equal(expect, bitmap.to_hex)
    end

    def test_parse_with_bin_bitmap_without_additional_bitmap
      message = String.new("\x70\x20\x00\x00\x00\x00\x80\x00165432123456789876000000000000001500986", encoding: "ASCII-8BIT")
      hex_bitmap = false
      bitmap_size = 64

      bitmap, _ = Bitmap.parse(message, hex_bitmap, bitmap_size)

      expect = String.new("\x70\x20\x00\x00\x00\x00\x80\x00", encoding: "ASCII-8BIT")
      assert_equal(expect, bitmap.to_bytes)
    end

    def test_parse_with_hex_bitmap_having_one_additional_bitmap
      message = "F02000000000800000000000000000021654321234567898760000000000000015009860a53ec23-8f0b-4328-a51f-b9202dad7b8b"
      hex_bitmap = true
      bitmap_size = 64

      bitmap, _ = Bitmap.parse(message, hex_bitmap, bitmap_size)

      expect = "F0200000000080000000000000000002"
      assert_equal(expect, bitmap.to_hex)
    end

    def test_parse_with_bin_bitmap_having_one_additional_bitmap
      message = String.new("\xF0\x20\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x021654321234567898760000000000000015009860a53ec23-8f0b-4328-a51f-b9202dad7b8b", encoding: 'ASCII-8BIT')
      hex_bitmap = false
      bitmap_size = 64

      bitmap, _ = Bitmap.parse(message, hex_bitmap, bitmap_size)

      expect = String.new("\xF0\x20\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x02", encoding: "ASCII-8BIT")
      assert_equal(expect, bitmap.to_bytes)
    end

    def test_parse_with_hex_bitmap_having_more_additionals_bitmap
      message = "808002blablabla"
      hex_bitmap = true
      bitmap_size = 8

      bitmap, _ = Bitmap.parse(message, hex_bitmap, bitmap_size)

      expect = "808002"
      assert_equal(expect, bitmap.to_hex)
      assert_equal(true, bitmap[23])
    end

    def test_parse_returning_remainder_of_message_small_bitmap_size
      message = "40blablabla"
      hex_bitmap = true
      bitmap_size = 8

      _, rest = Bitmap.parse(message, hex_bitmap, bitmap_size)

      expect = "blablabla"
      assert_equal(expect, rest)
    end

    def test_parse_returning_remainder_of_message_usual_bitmap_size
      message = "4000000000000000foobarbaz"
      hex_bitmap = true
      bitmap_size = 64

      _, rest = Bitmap.parse(message, hex_bitmap, bitmap_size)

      expect = "foobarbaz"
      assert_equal(expect, rest)
    end

    def test_parse_returning_remainder_of_message_big_bitmap_size
      message = "40000000000000000000000000000000bazbarfoo"
      hex_bitmap = true
      bitmap_size = 128

      _, rest = Bitmap.parse(message, hex_bitmap, bitmap_size)

      expect = "bazbarfoo"
      assert_equal(expect, rest)
    end

    def test_raises_on_wrong_bitmap_size
      e = assert_raises { Bitmap.new(nil, false, 1) }
      assert_equal(ISO8583Exception, e.class)
      assert_equal('wrong bitmap_size: 1', e.message)
    end

    def test_set_and_get_value
      bitmap = Bitmap.new(nil, false, 8)
      bitmap.set(2)
      assert_equal(true, bitmap[2])
      assert_equal(false, bitmap[1])
    end

    def test_avoid_set_bit_greater_than_size
      bitmap = Bitmap.new(nil, false, 8,  false)
      e = assert_raises { bitmap.set(9) }
      assert_equal(ISO8583Exception, e.class)
      assert_equal("can't set field 9, bitmap_size == 8", e.message)
    end

    def test_allow_set_bit_1_when_no_has_additional_bitmap
      bitmap = Bitmap.new(nil, false, 8,  false)
      bitmap.set(1)
      assert_equal(true, bitmap[1])
    end

    def test_avoid_set_bit_1_when_has_additional_bitmap
      bitmap = Bitmap.new(nil, false, 8,  true)
      e = assert_raises { bitmap.set(1) }
      assert_equal(ISO8583Exception, e.class)
      assert_equal("field 1 shouldn't be set (continuation bit is set automatically)", e.message)
    end

    def test_set_continuation_bit
      bitmap = Bitmap.new(nil, false, 8,  true)
      bitmap.set(20)
      assert_equal(true, bitmap[1])
      assert_equal(true, bitmap[9])
      assert_equal(false, bitmap[17])
      assert_equal(true, bitmap[20])
    end

    def test_set_continuation_bit_with_bitmap_size_of_64
      bitmap = Bitmap.new(nil, false, 64,  true)
      bitmap.set(180)
      assert_equal(true, bitmap[1])
      assert_equal(true, bitmap[65])
      assert_equal(false, bitmap[129])
      assert_equal(true, bitmap[180])
    end

    def test_unset_field
      bitmap = Bitmap.new(nil, false, 8,  false)
      assert_equal(false, bitmap[1])
      bitmap.set(1)
      assert_equal(true, bitmap[1])
      bitmap.unset(1)
      assert_equal(false, bitmap[1])
    end

    def test_to_s_bitmap_size_8_bits
      bitmap = Bitmap.new(nil, false, 8,  false)
      bitmap.set(2)
      bitmap.set(7)

      assert_equal('01000010', bitmap.to_s)
    end

    def test_to_s_bitmap_size_8_bits_having_additional_bitmap
      bitmap = Bitmap.new(nil, false, 8,  true)
      bitmap.set(2)
      bitmap.set(10)

      assert_equal('1100000001000000', bitmap.to_s)
    end

    def test_to_s_bitmap_size_64_bits
      bitmap = Bitmap.new(nil, false, 64,  true)
      bitmap.set(2)
      bitmap.set(3)
      bitmap.set(7)
      bitmap.set(11)
      bitmap.set(39)

      assert_equal('0110001000100000000000000000000000000010000000000000000000000000', bitmap.to_s)
    end

    def test_to_s_bitmap_size_64_bits_having_additional_bitmap
      bitmap = Bitmap.new(nil, false, 64,  true)
      bitmap.set(2)
      bitmap.set(3)
      bitmap.set(7)
      bitmap.set(11)
      bitmap.set(39)
      bitmap.set(127)

      assert_equal('11100010001000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000010', bitmap.to_s)
    end

    def test_to_hex_without_fields
      bitmap = Bitmap.new(nil, true, 8,  true)

      expected = "00"
      assert_equal(expected, bitmap.to_hex)
    end

    def test_to_hex_with_many_fields
      bitmap = Bitmap.new(nil, true, 64,  true)
      bitmap.set(2)
      bitmap.set(3)
      bitmap.set(4)
      bitmap.set(5)
      bitmap.set(6)
      bitmap.set(7)
      bitmap.set(8)
      bitmap.set(66)

      expected = "FF000000000000004000000000000000"

      assert_equal(expected, bitmap.to_hex)
    end

    def test_to_b_bitmap_size_8
      bitmap = Bitmap.new(nil, false, 8,  false)
      bitmap.set(2)
      bitmap.set(3)
      bitmap.set(4)
      bitmap.set(5)
      bitmap.set(6)
      bitmap.set(7)

      expected = String.new("\x7E", encoding: 'ASCII-8BIT')

      assert_equal(expected, bitmap.to_b)
    end

    def test_to_b_bitmap_size_8_having_additional_bitmap
      bitmap = Bitmap.new(nil, false, 8,  true)
      bitmap.set(2)
      bitmap.set(3)
      bitmap.set(4)
      bitmap.set(5)
      bitmap.set(6)
      bitmap.set(7)
      bitmap.set(11)

      expected = String.new("\xFE\x20", encoding: 'ASCII-8BIT')

      assert_equal(expected, bitmap.to_b)
    end

    def test_to_b_bitmap_size_64
      bitmap = Bitmap.new(nil, false, 64,  false)
      bitmap.set(2)
      bitmap.set(3)
      bitmap.set(4)
      bitmap.set(5)
      bitmap.set(6)
      bitmap.set(7)
      bitmap.set(8)
      bitmap.set(64)

      expected = String.new("\x7F\x00\x00\x00\x00\x00\x00\x01", encoding: 'ASCII-8BIT')

      assert_equal(expected, bitmap.to_b)
    end

    def test_to_b_bitmap_size_64_having_additional_bitmap
      bitmap = Bitmap.new(nil, false, 64,  true)
      bitmap.set(2)
      bitmap.set(3)
      bitmap.set(4)
      bitmap.set(5)
      bitmap.set(6)
      bitmap.set(7)
      bitmap.set(8)
      bitmap.set(66)

      expected = String.new("\xFF\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00", encoding: 'ASCII-8BIT')

      assert_equal(expected, bitmap.to_b)
    end
  end
end
