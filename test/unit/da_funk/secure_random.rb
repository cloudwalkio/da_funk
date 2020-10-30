class SecureRandomTest < DaFunk::Test.case
  def setup
    @uuid = DaFunk::SecureRandom.uuid
    @random_bytes = DaFunk::SecureRandom.random_bytes
  end

  def test_uuid
    assert_equal(36, @uuid.size)

    # Check time_hi_and_version and clock_seq_hi_res bits (RFC 4122 4.4)
    assert_equal('4', @uuid[14])
    assert_include(%w'8 9 a b', @uuid[19])
  end

  def test_random_bytes
    assert_equal(16, @random_bytes.size)
  end
end
