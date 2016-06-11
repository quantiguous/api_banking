require 'minitest_helper'

class TestFundsTransferByCustomerService < Minitest::Test
  def test_fundsTransferbyCustomerService_exists
    assert ApiBanking::FundsTransferByCustomerService
  end
  
  def test_it_gives_back_a_transfer_result
    
    address = ApiBanking::FundsTransferByCustomerService::Transfer::Address.new()
    beneficiary = ApiBanking::FundsTransferByCustomerService::Transfer::Beneficiary.new()
    request = ApiBanking::FundsTransferByCustomerService::Transfer::Request.new()
    
    address.address1 = 'Mumbai'
    
    beneficiary.fullName = 'Quantiguous Solutions'
    beneficiary.accountNo = '00001234567890'
    beneficiary.accountIFSC = 'RBIB0123456'
    beneficiary.address = address  # can also be a string
    
    request.uniqueRequestNo = SecureRandom.uuid.gsub!('-','')
    request.customerID = '000000'
    request.debitAccountNo = '00001234567890'
    request.transferType = 'NEFT'
    request.transferAmount = 20
    request.remitterToBeneficiaryInfo = 'FUND TRANSFER'
    
    request.beneficiary = beneficiary
    
    puts "#{self.class.name} : #{ApiBanking::FundsTransferByCustomerService.transfer(request)}"
    
  end  
  
  def test_it_gives_back_a_get_status_result

    request = ApiBanking::FundsTransferByCustomerService::GetStatus::Request.new()

    request.customerID = '000000'
    request.requestReferenceNo = '000000'

    puts "#{self.class.name} : #{ApiBanking::FundsTransferByCustomerService.get_status(request)}"
  end
end
