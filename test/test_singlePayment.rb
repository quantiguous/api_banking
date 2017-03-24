require 'minitest_helper'

class TestSinglePayment < Minitest::Test

  def test_it_gives_back_a_transfer_result
    
    remitter = ApiBanking::SinglePayment::Remitter.new()
    beneficiary = ApiBanking::SinglePayment::Beneficiary.new()
    header = ApiBanking::SinglePayment::ReqHeader.new()
    reqBody = ApiBanking::SinglePayment::ReqBody.new()
    request = ApiBanking::SinglePayment::Request.new()

    header.tranID          = rand.to_s[2..6]
    header.corpID          = 'QNTGS'
    
    reqBody.amount           = '200000'
    reqBody.modeOfPay        = 'NEFT'
    reqBody.remarks          = 'Self Transfer'

    remitter.accountNo        = '408888558888'
    remitter.accountName      = 'Gabriala Dcosta'
    
    beneficiary.accountIFSC      = 'SBIN0017942'
    beneficiary.accountNo        = '1006211030035980'
    beneficiary.fullName         = 'Sankha'
    beneficiary.address          = 'MUMBAI'
    beneficiary.email            = 'deep2005@gmail.com'
    beneficiary.mobileNo         = '7023923604'
    
    
    reqBody.remitter = remitter
    reqBody.beneficiary = beneficiary
    
    request.header = header
    request.body = reqBody
    
    puts "#{self.class.name} #{ApiBanking::SinglePayment.transfer(SinglePaymentEnvironment, request)}"   
  end  
  
end
