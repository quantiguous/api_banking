require 'minitest_helper'

class TestFundsTransferByCustomerService2 < Minitest::Test
  def test_fundsTransferbyCustomerService2_exists
    assert ApiBanking::FundsTransferByCustomerService2
  end
  
  def test_it_gives_back_a_transfer_result
    
    address = ApiBanking::FundsTransferByCustomerService2::Transfer::Address.new()
    beneficiary = ApiBanking::FundsTransferByCustomerService2::Transfer::Beneficiary.new()
    request = ApiBanking::FundsTransferByCustomerService2::Transfer::Request.new()
    
    address.address1 = 'Mumbai'
    
    beneficiary.fullName = 'Quantiguous Solutions'
    beneficiary.accountNo = '00001234567890'
    beneficiary.accountIFSC = 'RBIB0123456'
    beneficiary.address = address  # can also be a string
    
    request.uniqueRequestNo = SecureRandom.uuid.gsub!('-','')
    request.appID = 'APP12'
    request.purposeCode = 'PC01'
    request.customerID = '000000'
    request.debitAccountNo = '00001234567890'
    request.transferType = 'NEFT'
    request.transferAmount = 20
    request.remitterToBeneficiaryInfo = 'FUND TRANSFER'
    
    request.beneficiary = beneficiary
    
    puts "#{self.class.name} #{ApiBanking::FundsTransferByCustomerService2.transfer(request)}"
    
  end  
  
  def test_it_gives_back_a_get_status_result

    request = ApiBanking::FundsTransferByCustomerService2::GetStatus::Request.new()

    request.appID = 'APP12'
    request.customerID = '000000'
    request.requestReferenceNo = 'SOMEREFERENCENO'

    puts "#{self.class.name} : #{ApiBanking::FundsTransferByCustomerService2.get_status(request)}"
  end
end
