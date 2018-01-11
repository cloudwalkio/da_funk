
class FloatTest < DaFunk::Test.case
  def test_to_s_16_small_len
    assert_equal "200b1f", 2099999.to_s(16)
  end

  def test_to_s_16_medium_len
    assert_equal "775f05a073fff", 2099999999999999.to_s(16)
  end

  def test_to_s_16_big_len
    skip "Runtime stil have problem to deal with big numbers"
    assert_equal "6c9144c1c690d4cb3ffffff", 2099999999999999999999999999.to_s(16)
  end

  def test_to_s_10_big_len
    skip "Runtime stil have problem to deal with big numbers"
    assert_equal "2099999999999999999999999999", 2099999999999999999999999999.to_s(10)
  end

  def test_to_s_nil
    assert_equal "20.34", (20.34).to_s
  end

  def test_to_s_8
    assert_equal "10005437", (2099999.00).to_s(8)
  end

  def test_to_s_8
    assert_equal "1000000000101100011111", (2099999.00).to_s(2)
  end
end

