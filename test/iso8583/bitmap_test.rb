require_relative 'minitest_helper'

module ISO8583
  class TestBitmap < Minitest::Test
    def test_raises_on_wrong_bitmap_size
      e = assert_raises { Bitmap.new(nil, false, bitmap_size: 1) }
      assert_equal(ISO8583Exception, e.class)
      assert_equal('wrong bitmap_size: 1', e.message)
    end

    def test_set_and_get_value
      bitmap = Bitmap.new(nil, false, bitmap_size: 8)
      bitmap.set(2)
      assert_equal(true, bitmap[2])
      assert_equal(false, bitmap[1])
    end

    def test_avoid_set_bit_greater_than_size
      bitmap = Bitmap.new(nil, false, bitmap_size: 8, has_additional_bitmap: false)
      e = assert_raises { bitmap.set(9) }
      assert_equal(ISO8583Exception, e.class)
      assert_equal("can't set field 9, bitmap_size == 8", e.message)
    end

    def test_avoid_set_bit_1_when_has_additional_bitmap
      bitmap = Bitmap.new(nil, false, bitmap_size: 8)
      e = assert_raises { bitmap.set(1) }
      assert_equal(ISO8583Exception, e.class)
      assert_equal('Bits < 2 are not permitted (continuation bit is set automatically)', e.message)
    end

    def test_unset_field
      bitmap = Bitmap.new(nil, false, bitmap_size: 8, has_additional_bitmap: false)
      assert_equal(false, bitmap[1])
      bitmap.set(1)
      assert_equal(true, bitmap[1])
      bitmap.unset(1)
      assert_equal(false, bitmap[1])
    end

    def test_to_hex
      skip
      bitmap = Bitmap.new(nil, false, bitmap_size: 64, has_additional_bitmap: true)
      bitmap.set(2)
      bitmap.set(3)
      bitmap.set(4)
      bitmap.set(5)
      bitmap.set(6)
      bitmap.set(7)
      bitmap.set(8)
      bitmap.set(66)

      expected = "F000000040000000"

      assert_equal(expected, bitmap.to_hex)
    end
  end
end
