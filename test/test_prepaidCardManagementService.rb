require 'minitest_helper'

class TestPrepaidCardManagementService < Minitest::Test
  def test_prepaidCardManagementService_exists
    assert ApiBanking::PrepaidCardManagementService
  end

  def test_it_gives_back_a_register_card_result

    address = ApiBanking::PrepaidCardManagementService::RegisterCard::Address.new()
    idDocument = ApiBanking::PrepaidCardManagementService::RegisterCard::IDDocument.new()
    request = ApiBanking::PrepaidCardManagementService::RegisterCard::Request.new()

    address.addressLine1 = 'Shankar Lane'
    address.addressLine2 = 'Kandivali'
    address.city = 'Mumbai'
    address.state = 'Maharashtra'
    address.country = 'india'
    address.postalCode = '400101'

    idDocument.documentType = 'ration'
    idDocument.documentNo = 9009999999
    idDocument.countryOfIssue = 'india'

    request.uniqueRequestNo = SecureRandom.uuid.gsub!('-','')
    request.appID = 'APP13'
    request.title = 'Miss'
    request.firstName = 'Divya'
    request.lastName = 'Jayan'
    request.preferredName = 'divya'
    request.mobileNo = 9009999999
    request.gender = 'female'
    request.nationality = 'indian'
    request.birthDate = '1992-12-18'
    request.idDocument = idDocument
    request.address = address
    request.proxyCardNumber = '000000418970'
    # request.productCode = 'papp99'

    puts "#{self.class.name} #{ApiBanking::PrepaidCardManagementService.registerCard(PrepaidCardManagementServiceEnvironment, request)}"

  end

  def test_it_gives_back_a_load_card_result

    request = ApiBanking::PrepaidCardManagementService::LoadCard::Request.new()

    request.uniqueRequestNo = SecureRandom.uuid.gsub!('-','')
    request.appID = 'APP13'
    request.customerID = '2424'
    request.debitAccountNo = '001790700000090'
    request.mobileNo = '9008888888'
    request.loadAmount = '1000'

    puts "#{self.class.name} #{ApiBanking::PrepaidCardManagementService.loadCard(PrepaidCardManagementServiceEnvironment, request)}"
  end

  def test_it_gives_back_a_block_card_result

    request = ApiBanking::PrepaidCardManagementService::BlockCard::Request.new()

    request.uniqueRequestNo = SecureRandom.uuid.gsub!('-','')
    request.appID = 'APP13'
    request.mobileNo = '9008888881'

    puts "#{self.class.name} #{ApiBanking::PrepaidCardManagementService.blockCard(PrepaidCardManagementServiceEnvironment, request)}"
  end

end