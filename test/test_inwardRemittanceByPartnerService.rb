require 'minitest_helper'

class TestInwardRemittanceByPartnerService < Minitest::Test
  def test_inwardRemittanceByPartnerSerivce_exists
    assert ApiBanking::InwardRemittanceByPartnerService
  end
  
  def test_it_gives_back_a_remit_success_result

    remitterName = ApiBanking::InwardRemittanceByPartnerService::Remit::Name.new()
    remitterAddress = ApiBanking::InwardRemittanceByPartnerService::Remit::Address.new()
    remitterContact = ApiBanking::InwardRemittanceByPartnerService::Remit::Contact.new()
    remitterIdentities = ApiBanking::InwardRemittanceByPartnerService::Remit::Identities.new()
    remIdentity1 = ApiBanking::InwardRemittanceByPartnerService::Remit::Identity.new()
    remIdentity2 = ApiBanking::InwardRemittanceByPartnerService::Remit::Identity.new()
    beneName = ApiBanking::InwardRemittanceByPartnerService::Remit::Name.new()
    beneAddress = ApiBanking::InwardRemittanceByPartnerService::Remit::Address.new()
    beneContact = ApiBanking::InwardRemittanceByPartnerService::Remit::Contact.new()
    beneIdentities = ApiBanking::InwardRemittanceByPartnerService::Remit::Identities.new()
    beneIdentity1 = ApiBanking::InwardRemittanceByPartnerService::Remit::Identity.new()
    request = ApiBanking::InwardRemittanceByPartnerService::Remit::Request.new()

    remitterName.fullName = 'Remitter'
    remitterAddress.address1 = 'MUMBAI'
    remitterContact.mobileNo = '9833393350'

    remIdentity1.idType = 'LicenceNumber'
    remIdentity1.idNumber = '123234567394'
    remIdentity1.idCountry = 'AF'
    remIdentity1.issueDate = '2015-12-23'
    remIdentity1.expiryDate = '2020-11-22'
    remIdentity2.idType = 'aadhaar'
    remIdentity2.idNumber = '09876889890'
    remIdentity2.idCountry = 'IN'
    remIdentity2.issueDate = '2014-12-12'
    remIdentity2.expiryDate = '2015-12-12'
    remIdentities = [remIdentity1, remIdentity2]
    remitterIdentities.identity = remIdentities

    beneName.fullName = 'Beneficiary'
    beneAddress.address1 = 'MUMBAI'
    beneContact.mobileNo = '9891091010'  
    beneIdentities.identity = nil

    request.uniqueRequestNo = SecureRandom.uuid.gsub!('-','')
    request.partnerCode = 'TRANGLO'
    request.remitterType = 'I'
    request.remitterName = remitterName
    request.remitterAddress = remitterAddress
    request.remitterContact = remitterContact
    request.remitterIdentities = remitterIdentities
    request.beneficiaryType = 'I'
    request.beneficiaryName = beneName
    request.beneficiaryAddress = beneAddress
    request.beneficiaryContact = beneContact
    request.beneficiaryIdentities = beneIdentities
    request.beneficiaryAccountNo = '9551457076'
    request.beneficiaryIFSC = 'DNSB0000001'
    request.transferType = 'NEFT'
    request.transferCurrencyCode = 'INR'
    request.transferAmount = 20
    request.remitterToBeneficiaryInfo = 'Remitter Hit Provides ID'
    request.purposeCode = 'PC01'

    remitResult = ApiBanking::InwardRemittanceByPartnerService.remit(request)
    p remitResult
    refute_equal remitResult.uniqueResponseNo, nil
  end

end