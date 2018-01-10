class HelperKlass
  include DaFunk::Helper
end

class HelperTest < DaFunk::Test.case
  def setup
    @helper = HelperKlass.new
  end

  def test_number_to_currency_basic
    assert_equal  "0.00", @helper.number_to_currency("")
    assert_equal  "0.01", @helper.number_to_currency("1")
    assert_equal  "0.10", @helper.number_to_currency("10")
    assert_equal  "0.01", @helper.number_to_currency("01")
    assert_equal  "1.00", @helper.number_to_currency("100")
    assert_equal "10.00", @helper.number_to_currency("1000")
  end

  def test_number_to_currency_separator
    assert_equal "100.00", @helper.number_to_currency("10000", {:separator => "."})
    assert_equal "100,00", @helper.number_to_currency("10000", {:separator => ","})
  end

  def test_number_to_currency_delimiter
    assert_equal "1.000.00", @helper.number_to_currency("100000", {:delimiter => "."})
    assert_equal "1,000.00", @helper.number_to_currency("100000", {:delimiter => ","})
  end

  def test_number_to_currency_precision
    assert_equal "100.00", @helper.number_to_currency("10000", {:precision => 2})
    assert_equal "10.000", @helper.number_to_currency("10000", {:precision => 3})
    assert_equal "1,000.000", @helper.number_to_currency("1000000", {:precision => 3})
  end

  def test_number_to_currency_fixnum
    assert_equal "100.00", @helper.number_to_currency(10000, {:precision => 2})
    assert_equal "10.000", @helper.number_to_currency(10000, {:precision => 3})
    assert_equal "1,000.000", @helper.number_to_currency(1000000, {:precision => 3})
  end

  def test_number_to_currency_float
    assert_equal "100.34", @helper.number_to_currency(100.34, {:precision => 2})
    assert_equal "100.341", @helper.number_to_currency(100.341, {:precision => 3})
    assert_equal "10,000.341", @helper.number_to_currency(10000.341, {:precision => 3})
  end

  def test_helper_include_scope
    assert HelperKlass.methods.include? :attach
    assert HelperKlass.new.methods.include? :attach
  end
end

