require 'minitest_helper'

class InstantMoneyTransferService < Minitest::Test
  
  def test_it_gives_back_a_initiateTransfer_result
    
    request = ApiBanking::InstantMoneyTransferService::InitiateTransfer::Request.new()
        
    request.uniqueRequestNo = SecureRandom.uuid.gsub!('-','')
    request.appID = 'app12345'
    request.customerID = '42989'
    request.beneficiaryMobileNo = '9637257928'
    request.transferAmount = 2000
    request.passCode = 1734
    request.remitterToBeneficiaryInfo = 'FUND TRANSFER'
        
    puts "#{self.class.name} : #{ApiBanking::InstantMoneyTransferService.transfer(request)}"
    
  end  
  
end
