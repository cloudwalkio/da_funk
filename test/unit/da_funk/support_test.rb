
class CwAsdfsafAsfsXml
end

class DaFunkSupportTest < DaFunk::Test.case
  def test_remove_extension
    assert_equal "cw_asdfsaf_asfs", Device::Support.remove_extension("asdfas/asfasf/cw_asdfsaf_asfs.posxml")
  end

  def test_camelize
    name = Device::Support.remove_extension("asdfas/asfasf/cw_asdfsaf_asfs.posxml")
    assert_equal "CwAsdfsafAsfs", Device::Support.camelize(name)
  end

  def test_constantize
    name = Device::Support.remove_extension("asdfas/asfasf/cw_asdfsaf_asfs.posxml")
    camel = Device::Support.camelize(name) + "Xml"
    assert_equal CwAsdfsafAsfsXml, Device::Support.constantize(camel)
  end

  def test_klass_to_file
    assert_equal "cw_asdfsaf_asfs_xml", CwAsdfsafAsfsXml.to_s.snakecase
  end
end

