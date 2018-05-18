
class StringTest < DaFunk::Test.case
  def test_to_mask_number
    assert_equal "(12) 341-234", "12341234".to_mask("(99) 999-999")
  end

  def test_to_mask_letters
    assert_equal "(12) 341-234", "12341234".to_mask("(99) 999-999")
  end

  def test_to_mask_alpha
    assert_equal "(12) ac34-123", "12ac341234".to_mask("(99) 9AAA-999")
  end

  def test_to_mask_number_bigger_than_value
    assert_equal "874948315", "874948315".to_mask("9999999999")
  end

  def test_interger_check_false_5A179759
    assert_false "5A179759".integer?
  end

  def test_interger_check_true_5A179759
    assert "5179759".integer?
  end

  def test_interger_check_true_big
    assert "51797590000000000000".integer?
  end

  def test_interger_check_false_0A179759
    assert_false "0A179759".integer?
  end

  def test_interger_check_true_0517030931
    assert "0517030931".integer?
  end

  def test_interger_check_false_empty
    assert_false "".integer?
  end
end

