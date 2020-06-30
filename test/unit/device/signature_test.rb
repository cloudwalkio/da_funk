require 'funky-mock'

class SignatureTest < DaFunk::Test.case
  def test_signature_should_be_updated
    FileDb.new(Device::Signature::FILE).update_attributes({'signer' => 'whatever'})
    DaFunk::ParamsDat.file = {'signer' => 'thebestsignature'}

    assert_equal Device::Signature::CONVERTED, Device::Signature.convert
  end

  def test_signature_file_not_found
    FunkyMock::Mock.new
    Device::Signature.stubs(:load).returns(nil)

    assert_equal Device::Signature::FILE_NOT_FOUND, Device::Signature.convert
  end

  def test_signature_is_the_same
    FileDb.new(Device::Signature::FILE).update_attributes({'signer' => 'whatever'})
    DaFunk::ParamsDat.file = {'signer' => 'whatever'}

    assert_equal Device::Signature::IS_THE_SAME, Device::Signature.convert
  end
end
