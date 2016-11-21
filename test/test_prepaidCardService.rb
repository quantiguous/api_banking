require 'minitest_helper'

class TestPrepaidCardService < Minitest::Test
  def test_prepaidCardService_exists
    assert ApiBanking::PrepaidCardService
  end

  def test_it_gives_back_an_add_beneficiary_result

    request = ApiBanking::PrepaidCardService::AddBeneficiary::Request.new()

    request.uniqueRequestNo = SecureRandom.uuid.gsub!('-','')
    request.appID = 'APP13'
    request.mobileNo = '9011281324'
    request.beneficiaryName = 'Divya'
    request.beneficiaryAccountNo = '001790700000088'
    request.beneficiaryIFSC = 'HDFC0000260'

    addBeneficiaryResult = ApiBanking::PrepaidCardService.addBeneficiary(PrepaidCardServiceEnvironment, request)
    puts "#{self.class.name} : #{addBeneficiaryResult}"
    refute_equal addBeneficiaryResult[:uniqueResponseNo], nil
  end

  def test_it_gives_back_a_get_balance_result

    request = ApiBanking::PrepaidCardService::GetBalance::Request.new()

    request.appID = 'APP13'
    request.mobileNo = '9009999999'

    getBalanceResult = ApiBanking::PrepaidCardService.getBalance(PrepaidCardServiceEnvironment, request)
    puts "#{self.class.name} : #{getBalanceResult}"
    refute_equal getBalanceResult[:cardBalance], nil
  end

  def test_it_gives_back_a_get_customer_detail_result

    request = ApiBanking::PrepaidCardService::GetCustomerDetail::Request.new()

    request.appID = 'APP13'
    request.mobileNo = '9009999999'

    getCustomerDetailResult = ApiBanking::PrepaidCardService.getCustomerDetail(PrepaidCardServiceEnvironment, request)
    puts "#{self.class.name} : #{getCustomerDetailResult}"
    refute_equal getCustomerDetailResult[:customerEmail], nil
  end

  def test_it_gives_back_a_get_beneficiaries_result

    request = ApiBanking::PrepaidCardService::GetBeneficiaries::Request.new()

    request.appID = 'APP13'
    request.mobileNo = '9009999999'
    request.numBeneficiaries = 1

    getBeneficiariesResult = ApiBanking::PrepaidCardService.getBeneficiaries(PrepaidCardServiceEnvironment, request)
    puts "#{self.class.name} : #{getBeneficiariesResult}"
    refute_equal getBeneficiariesResult[:numBeneficiaries], 1
  end


  def test_it_gives_back_one_transaction

    request = ApiBanking::PrepaidCardService::GetTransactions::Request.new()

    request.appID = 'APP13'
    request.mobileNo = '1474520669'
    request.numTransactions = 1

    getTransactionsResult = ApiBanking::PrepaidCardService.getTransactions(PrepaidCardServiceEnvironment, request)
    puts "#{self.class.name} : #{getTransactionsResult}"
    assert_equal getTransactionsResult[:transactionsArray][:transaction].count, 1
  end

  def test_it_gives_back_multiple_transactions

    request = ApiBanking::PrepaidCardService::GetTransactions::Request.new()

    request.appID = 'APP13'
    request.mobileNo = '9008888888'
    request.numTransactions = 1

    getTransactionsResult = ApiBanking::PrepaidCardService.getTransactions(PrepaidCardServiceEnvironment, request)
    puts "#{self.class.name} : #{getTransactionsResult}"
    assert_equal getTransactionsResult[:transactionsArray][:transaction].count, 1
  end

  def test_it_gives_back_a_pay_to_account_result

    request = ApiBanking::PrepaidCardService::PayToAccount::Request.new()

    request.uniqueRequestNo = SecureRandom.uuid.gsub!('-','')
    request.appID = 'APP13'
    request.mobileNo = '9008888888'
    request.encryptedPIN = '338BE5673C6B86CF'
    request.transferType = 'NEFT'
    request.beneficiaryName = 'Divya'
    request.beneficiaryAccountNo = '001790700021188'
    request.beneficiaryIFSC = 'HDFC0000260'
    request.transferAmount = '1000'
    request.remitterToBeneficiaryInfo = 'FUNDS TRANSFER'

    payToAccountResult = ApiBanking::PrepaidCardService.payToAccount(PrepaidCardServiceEnvironment, request)
    puts "#{self.class.name} : #{payToAccountResult}"
    refute_equal payToAccountResult[:transferType], nil
  end

  def test_it_gives_back_a_pay_to_contact_result

    request = ApiBanking::PrepaidCardService::PayToContact::Request.new()

    request.uniqueRequestNo = SecureRandom.uuid.gsub!('-','')
    request.appID = 'APP13'
    request.mobileNo = '9008888888'
    request.encryptedPIN = '338BE5673C6B86CF'
    request.contactName = 'DIVYA'
    request.contactMobileNo = '9009999999'
    request.transferAmount = '1000'

    payToContactResult = ApiBanking::PrepaidCardService.payToContact(PrepaidCardServiceEnvironment, request)
    puts "#{self.class.name} : #{payToContactResult}"
    refute_equal payToContactResult[:transferType], nil
  end

  def test_it_gives_back_a_top_up_result

    request = ApiBanking::PrepaidCardService::TopUp::Request.new()

    request.uniqueRequestNo = SecureRandom.uuid.gsub!('-','')
    request.appID = 'APP13'
    request.mobileNo = '9008888888'
    request.encryptedPIN = '338BE5673C6B86CF'
    request.billerID = 'NEFT'
    request.subscriberID = '987878787876'
    request.topupAmount = '100'

    topUpResult = ApiBanking::PrepaidCardService.topUp(PrepaidCardServiceEnvironment, request)
    puts "#{self.class.name} : #{topUpResult}"
    refute_equal topUpResult[:uniqueResponseNo], nil
  end

  def test_it_gives_back_a_verify_pin_result

    request = ApiBanking::PrepaidCardService::VerifyPIN::Request.new()

    request.appID = 'APP13'
    request.mobileNo = '9008888888'
    request.pinBlock = '338BE5673C6B86CF'

    verifyPINResult = ApiBanking::PrepaidCardService.verifyPIN(PrepaidCardServiceEnvironment, request)
    puts "#{self.class.name} : #{verifyPINResult}"
    refute_equal verifyPINResult[:version], nil
  end
end