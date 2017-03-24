require 'minitest_helper'

class TestGetAccountBalance < Minitest::Test

  def test_it_returns_an_account_balance

    header = ApiBanking::GetAccountBalance::ReqHeader.new()
    reqBody = ApiBanking::GetAccountBalance::ReqBody.new()
    request = ApiBanking::GetAccountBalance::Request.new()

    header.corpID          = 'QNTGS'
    header.approverID      = 'A001'

    reqBody.accountNo = '408888558888'

    request.header = header
    request.body = reqBody

    result = ApiBanking::GetAccountBalance.get_account_balance(GetAccountBalanceEnvironment, request)
    puts "#{self.class.name} #{result}"

    assert_equal result.instance_of?(ApiBanking::GetAccountBalance::Result), true
  end
  
  def test_it_returns_a_fault_for_an_invalid_account_no

    header = ApiBanking::GetAccountBalance::ReqHeader.new()
    reqBody = ApiBanking::GetAccountBalance::ReqBody.new()
    request = ApiBanking::GetAccountBalance::Request.new()

    header.corpID          = 'QNTGS'
    header.approverID      = 'A001'

    reqBody.accountNo = '128888558890'

    request.header = header
    request.body = reqBody

    result = ApiBanking::GetAccountBalance.get_account_balance(GetAccountBalanceEnvironment, request)
    puts "#{self.class.name} #{result}"

    assert_equal result.instance_of?(ApiBanking::Fault), true
  end
  
end
