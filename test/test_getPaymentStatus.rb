require 'minitest_helper'

class TestGetPaymentStatus < Minitest::Test

  def test_it_returns_a_payment_status

    header = ApiBanking::GetPaymentStatus::ReqHeader.new()
    reqBody = ApiBanking::GetPaymentStatus::ReqBody.new()
    request = ApiBanking::GetPaymentStatus::Request.new()

    header.corpID          = 'QNTGS'
    header.approverID      = 'A001'

    reqBody.referenceNo = '102921189089080'

    request.header = header
    request.body = reqBody

    result = ApiBanking::GetPaymentStatus.get_status(GetPaymentStatusEnvironment, request)
    puts "#{self.class.name} #{result}"

    assert_equal result.instance_of?(ApiBanking::GetPaymentStatus::Result), true
  end
  
  def test_it_returns_a_fault_for_an_invalid_reference_no

    header = ApiBanking::GetPaymentStatus::ReqHeader.new()
    reqBody = ApiBanking::GetPaymentStatus::ReqBody.new()
    request = ApiBanking::GetPaymentStatus::Request.new()

    header.corpID          = 'QNTGS'
    header.approverID      = 'A001'

    reqBody.referenceNo = '1111111111'

    request.header = header
    request.body = reqBody

    result = ApiBanking::GetPaymentStatus.get_status(GetPaymentStatusEnvironment, request)
    puts "#{self.class.name} #{result}"

    assert_equal result.instance_of?(ApiBanking::Fault), true
  end
  
end
