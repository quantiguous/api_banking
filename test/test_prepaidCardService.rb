require 'minitest_helper'

class TestPrepaidCardService < Minitest::Test
  def test_prepaidCardService_exists
    assert ApiBanking::PrepaidCardService
  end
  
  # def test_it_gives_back_a_add_beneficiary_result
  #
  #   request = ApiBanking::PrepaidCardService::AddBeneficiary::Request.new()
  #
  #   request.uniqueRequestNo = SecureRandom.uuid.gsub!('-','')
  #   request.appID = 'APP13'
  #   request.mobileNo = '9011281324'
  #   request.beneficiaryName = 'Divya'
  #   request.beneficiaryAccountNo = '001790700000088'
  #   request.beneficiaryIFSC = 'HDFC0000260'
  #
  #   addBeneficiaryResult = ApiBanking::PrepaidCardService.addBeneficiary(request)
  #   puts "#{self.class.name} : #{addBeneficiaryResult}"
  #   refute_equal addBeneficiaryResult[:uniqueResponseNo], nil
  # end
  #
  # def test_it_gives_back_a_get_beneficiaries_result
  #
  #   request = ApiBanking::PrepaidCardService::GetBeneficiaries::Request.new()
  #
  #   request.appID = 'APP13'
  #   request.mobileNo = '9009999999'
  #   request.numBeneficiaries = 1
  #
  #   getBeneficiariesResult = ApiBanking::PrepaidCardService.getBeneficiaries(request)
  #   puts "#{self.class.name} : #{getBeneficiariesResult}"
  #   refute_equal getBeneficiariesResult[:numBeneficiaries], nil
  # end
  #
  # def test_it_gives_back_a_get_transactions_result
  #
  #   request = ApiBanking::PrepaidCardService::GetTransactions::Request.new()
  #
  #   request.appID = 'APP13'
  #   request.mobileNo = '1474520669'
  #   request.numTransactions = 1
  #
  #   getTransactionsResult = ApiBanking::PrepaidCardService.getTransactions(request)
  #   puts "#{self.class.name} : #{getTransactionsResult}"
  #   assert_equal getTransactionsResult[:transactionsArray][:transaction].count, 1
  # end

end