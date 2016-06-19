require 'minitest_helper'

class TestDomesticRemittanceByPartnerService < Minitest::Test
  def test_domesticRemittanceByPartnerService_exists
    assert ApiBanking::DomesticRemittanceByPartnerService
  end
  
  def test_it_gives_back_a_remit_result
    
    remitterAddress = ApiBanking::DomesticRemittanceByPartnerService::Remit::Address.new()
    beneficiaryAddress = ApiBanking::DomesticRemittanceByPartnerService::Remit::Address.new()
    remitterContact = ApiBanking::DomesticRemittanceByPartnerService::Remit::Contact.new()
    beneficiaryContact = ApiBanking::DomesticRemittanceByPartnerService::Remit::Contact.new()
    request = ApiBanking::DomesticRemittanceByPartnerService::Remit::Request.new()
    
    remitterAddress.address1 = 'MUMBAI'
    beneficiaryAddress.address1 = 'MUMBAI'
    remitterContact.mobileNo = '9998880088'
    beneficiaryContact.mobileNo = '9998880088'
    
    request.uniqueRequestNo = SecureRandom.uuid.gsub!('-','')
    request.partnerCode = 'PC01'
    request.customerID = '2424'
    request.debitAccountNo = '1234567890'
    request.remitterAccountNo = '1234567890'
    request.remitterIFSC = 'QWER0123456'
    request.remitterName = 'John'
    request.remitterAddress = remitterAddress
    request.remitterContact = remitterContact
    request.beneficiaryName = 'Martin'
    request.beneficiaryAddress = beneficiaryAddress
    request.beneficiaryContact = beneficiaryContact
    request.beneficiaryAccountNo = '1234567890'
    request.beneficiaryIFSC = 'QWER0123456'
    request.transferType = 'NEFT'
    request.transferCurrencyCode = 'INR'
    request.transferAmount = 20
    request.remitterToBeneficiaryInfo = 'FUND TRANSFER'

    puts "#{self.class.name} #{ApiBanking::DomesticRemittanceByPartnerService.remit(request)}"
    
  end  
  
  def test_it_gives_back_a_get_status_result

    request = ApiBanking::DomesticRemittanceByPartnerService::GetStatus::Request.new()

    request.partnerCode = 'APP12'
    request.requestReferenceNo = 'A0EE09FE6E98410C84774CC486657AF1'

    puts "#{self.class.name} #{ApiBanking::DomesticRemittanceByPartnerService.get_status(request)}"
  end

  def test_it_gives_back_a_get_balance_result

    request = ApiBanking::DomesticRemittanceByPartnerService::GetBalance::Request.new()

    request.partnerCode = 'APP12'
    request.customerID = '2424'
    request.accountNo = '1234567890'

    puts "#{self.class.name} #{ApiBanking::DomesticRemittanceByPartnerService.get_balance(request)}"
  end

  def test_it_gives_back_a_get_transactions_result

    request = ApiBanking::DomesticRemittanceByPartnerService::GetTransactions::Request.new()

    dateRange = ApiBanking::DomesticRemittanceByPartnerService::GetTransactions::DateRange.new()
    dateRange.fromDate = '2015-12-12'
    dateRange.toDate = '2016-05-12'

    request.partnerCode = 'APP12'
    request.customerID = '2424'
    request.accountNo = '1234567890'
    request.dateRange = dateRange

    puts "#{self.class.name} #{ApiBanking::DomesticRemittanceByPartnerService.get_transactions(request)}"
  end
end
