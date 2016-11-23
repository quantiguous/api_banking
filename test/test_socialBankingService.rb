require 'minitest_helper'

class TestSocialBankingService < Minitest::Test
  def test_socialBankingService_exists
    assert ApiBanking::SocialBankingService
  end

  def test_it_gives_back_a_get_transactions_result_with_multiple_transactions_for_a_request_without_customer_alternate_id

    customerIdentity = ApiBanking::SocialBankingService::GetTransactions::CustomerIdentity.new()
    accountIdentity = ApiBanking::SocialBankingService::GetTransactions::AccountIdentity.new()
    request = ApiBanking::SocialBankingService::GetTransactions::Request.new()

    customerIdentity.customerID = '2298040'

    accountIdentity.accountNo = '005586500000069'

    request.appID = '123456'

    request.customerIdentity = customerIdentity
    request.deviceID = 'Divya'
    request.accountIdentity = accountIdentity
    request.numTransactions = 3

    getTransactionsResult =ApiBanking::SocialBankingService.getTransactions(SocialBankingServiceEnvironment, request)
    puts "#{self.class.name} #{getTransactionsResult}"
    assert_equal getTransactionsResult[:numTransactions], "3"
  end
  
  def test_it_gives_back_a_get_transactions_result_with_one_transaction_for_a_request_without_customer_alternate_id

    customerIdentity = ApiBanking::SocialBankingService::GetTransactions::CustomerIdentity.new()
    accountIdentity = ApiBanking::SocialBankingService::GetTransactions::AccountIdentity.new()
    request = ApiBanking::SocialBankingService::GetTransactions::Request.new()

    customerIdentity.customerID = '2298040'

    accountIdentity.accountNo = '005586500000069'

    request.appID = '123456'

    request.customerIdentity = customerIdentity
    request.deviceID = 'Divya'
    request.accountIdentity = accountIdentity
    request.numTransactions = 1

    getTransactionsResult =ApiBanking::SocialBankingService.getTransactions(SocialBankingServiceEnvironment, request)
    puts "#{self.class.name} #{getTransactionsResult}"
    assert_equal getTransactionsResult[:numTransactions], "1"
  end

  def test_it_gives_back_fault_for_a_get_transactions_request_with_customer_alternate_id_and_invalid_id

    customerIdentity = ApiBanking::SocialBankingService::GetTransactions::CustomerIdentity.new()
    customerAlternateID = ApiBanking::SocialBankingService::GetTransactions::CustomerAlternateID.new()
    genericID = ApiBanking::SocialBankingService::GetTransactions::GenericID.new()
    accountIdentity = ApiBanking::SocialBankingService::GetTransactions::AccountIdentity.new()
    request = ApiBanking::SocialBankingService::GetTransactions::Request.new()

    genericID.idType = 'passport'
    genericID.idValue = '1234567890'

    customerAlternateID.genericID = genericID

    customerIdentity.customerAlternateID = customerAlternateID

    accountIdentity.registeredAccount = true

    request.appID = '123456'
    request.customerIdentity = customerIdentity
    request.deviceID = 'Divya'
    request.accountIdentity = accountIdentity
    request.numTransactions = 3

    getTransactionsResult =  ApiBanking::SocialBankingService.getTransactions(SocialBankingServiceEnvironment, request)
    puts "#{self.class.name} #{getTransactionsResult}"
    assert_equal getTransactionsResult[:code], 'ns:E1006'
  end

end