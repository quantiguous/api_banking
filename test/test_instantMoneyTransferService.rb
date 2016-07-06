require 'minitest_helper'

class InstantMoneyTransferService < Minitest::Test
  
  def test_it_gives_back_a_initiateTransfer_result

    request = ApiBanking::InstantMoneyTransferService::InitiateTransfer::Request.new()

    request.uniqueRequestNo = SecureRandom.uuid.gsub!('-','')
    request.appID = 'app12345'
    request.customerID = '42989'
    request.beneficiaryMobileNo = '9637257928'
    request.transferAmount = 100
    request.passCode = 1734
    request.remitterToBeneficiaryInfo = 'FUND TRANSFER'

    puts "#{self.class.name} : #{ApiBanking::InstantMoneyTransferService.transfer(request)}"

  end

  def test_it_gives_back_a_cancelTransfer_result

    request = ApiBanking::InstantMoneyTransferService::CancelTransfer::Request.new()

    request.uniqueRequestNo = SecureRandom.uuid.gsub!('-','')
    request.appID = 'app12345'
    request.customerID = '42989'
    request.initiateTransferRequestNo = '1234'
    request.reasonToCancel = 'Cancel'

    puts "#{self.class.name} : #{ApiBanking::InstantMoneyTransferService.cancel_transfer(request)}"

  end

  def test_it_gives_back_a_addBeneficiary_result

    beneficiaryAddress = ApiBanking::InstantMoneyTransferService::AddBeneficiary::Address.new()
    request = ApiBanking::InstantMoneyTransferService::AddBeneficiary::Request.new()

    request.uniqueRequestNo = SecureRandom.uuid.gsub!('-','')
    request.appID = 'app12345'
    request.customerID = '42989'
    request.beneficiaryMobileNo = '9538321404'
    request.beneficiaryName = 'Lavanya'
    beneficiaryAddress.addressLine = 'Mysore'
    beneficiaryAddress.cityName = 'Hootagali'
    beneficiaryAddress.postalCode = '670307'
    request.beneficiaryAddress = beneficiaryAddress

    puts "#{self.class.name} : #{ApiBanking::InstantMoneyTransferService.add_beneficiary(request)}"

  end

  
  def test_it_gives_back_a_get_beneficiaries_result

    request = ApiBanking::InstantMoneyTransferService::GetBeneficiaries::Request.new()

    dateRange = ApiBanking::InstantMoneyTransferService::GetBeneficiaries::DateRange.new()
    dateRange.fromDate = '2015-12-12'
    dateRange.toDate = '2016-05-12'

    request.appID = 'app12345'
    request.customerID = '42989'
    request.dateRange = dateRange
    request.numBeneficiaries = 1

    puts "#{self.class.name} #{ApiBanking::InstantMoneyTransferService.get_beneficiaries(request)}"
  end

  def test_it_gives_back_a_deleteBeneficiary_result

    request = ApiBanking::InstantMoneyTransferService::DeleteBeneficiary::Request.new()
        
    request.uniqueRequestNo = SecureRandom.uuid.gsub!('-','')
    request.appID = 'app12345'
    request.customerID = '42989'
    request.beneficiaryMobileNo = '9538321404'
        
    puts "#{self.class.name} : #{ApiBanking::InstantMoneyTransferService.delete_beneficiary(request)}"   
  end 
end