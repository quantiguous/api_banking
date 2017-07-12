require 'minitest_helper'

class TestPanInquiry < Minitest::Test

  def test_it_returns_the_details_of_a_valid_pan_number

    header = ApiBanking::PanInquiry::ReqHeader.new()
    reqBody = ApiBanking::PanInquiry::ReqBody.new()
    request = ApiBanking::PanInquiry::Request.new()

    header.tranID          = rand.to_s[2..6]
    header.corpID          = 'QNTGS'

    reqBody.panNumber = 'AMXPP6546K'

    request.header = header
    request.body = reqBody

    result = ApiBanking::PanInquiry.pan_inquiry(PanInquiryEnvironment, request)
    puts "#{self.class.name} #{result}"

    assert_equal result.instance_of?(ApiBanking::PanInquiry::Result), true
    assert_equal result.panStatus, 'E'
  end

  def test_it_does_not_return_the_details_of_invalid_pan

    header = ApiBanking::PanInquiry::ReqHeader.new()
    reqBody = ApiBanking::PanInquiry::ReqBody.new()
    request = ApiBanking::PanInquiry::Request.new()

    header.tranID          = rand.to_s[2..6]
    header.corpID          = 'QNTGS'

    reqBody.panNumber = '0000000000'

    request.header = header
    request.body = reqBody

    result = ApiBanking::PanInquiry.pan_inquiry(PanInquiryEnvironment, request)
    puts "#{self.class.name} #{result}"

    assert_equal result.instance_of?(ApiBanking::PanInquiry::Result), true
    assert_equal result.panStatus, 'N'
  end
end
