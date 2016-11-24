require 'minitest_helper'

class TestVirtualCardManagementService < Minitest::Test
  def test_virtualCardManagementService_exists
    assert ApiBanking::VirtualCardManagementService
  end

  def test_it_gives_back_a_register_card_result

    address = ApiBanking::VirtualCardManagementService::RegisterCard::Address.new()
    request = ApiBanking::VirtualCardManagementService::RegisterCard::Request.new()

    address.addressLine1 = 'Shankar Lane'
    address.addressLine2 = 'Kandivali'
    address.city = 'Mumbai'
    address.state = 'Maharashtra'
    address.country = 'india'
    address.postalCode = '400101'

    request.uniqueRequestNo = SecureRandom.uuid.gsub!('-','')
    request.appID = 'APP12'
    request.title = 'Miss'
    request.firstName = 'Divya'
    request.lastName = 'Jayan'
    request.preferredName = 'divya'
    request.mobileNo = Time.now.to_i
    request.gender = 'female'
    request.nationality = 'indian'
    request.birthDate = '1992-12-18'
    request.address = address
    request.emailID = Time.now.to_i.to_s + '@gmail.com'
    request.password = 'iFQqK3Sw4UfPsmmYzSMJxQ==--9Ljp00QD4vzGU6gPdvg5Qg=='

    registerCardResult = ApiBanking::VirtualCardManagementService.registerCard(VirtualCardManagementServiceEnvironment, request)
    puts "#{self.class.name} #{registerCardResult}"
    refute_equal registerCardResult[:uniqueResponseNo], nil
  end

  def test_it_gives_back_a_block_card_result

    request = ApiBanking::VirtualCardManagementService::BlockCard::Request.new()

    request.uniqueRequestNo = SecureRandom.uuid.gsub!('-','')
    request.appID = 'APP12'
    request.userUID = '2424'
    request.emailID = '1474448773@gmail.com'
    request.password = 'bnmkj123'

    blockCardResult = ApiBanking::VirtualCardManagementService.blockCard(VirtualCardManagementServiceEnvironment, request)
    puts "#{self.class.name} #{blockCardResult}"
    refute_equal blockCardResult[:uniqueResponseNo], nil
  end

  def test_it_gives_back_a_get_card_detail_result

    request = ApiBanking::VirtualCardManagementService::GetCardDetail::Request.new()

    request.appID = 'APP12'
    request.cardUID = 'ceecb11d0badb0679badf004a7e59de0'
    request.emailID = '1474448773@gmail.com'
    request.password = 'DE+piR2rKfYOfVya0TNBQcSVdBurWfqMNkEcI+pU0A6ptXz4jwojGpbHMH4eLTcJ--XZbd6Dw0i4mExnpbYselwQ=='

    getCardDetailResult = ApiBanking::VirtualCardManagementService.getCardDetail(VirtualCardManagementServiceEnvironment, request)
    puts "#{self.class.name} #{getCardDetailResult}"
    refute_equal getCardDetailResult[:cardUID], nil
  end

end