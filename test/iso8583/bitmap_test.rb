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
      bitmap = Bitmap.new(nil, false, bitmap_size: 8)
      e = assert_raises { bitmap[9] =  true }
      assert_equal(ISO8583Exception, e.class)
      assert_equal('Bits > 8 are not permitted. bitmap_size == 8', e.message)
    end
  end
end
