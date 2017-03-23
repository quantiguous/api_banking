require 'minitest_helper'

class TestAccountStatement < Minitest::Test

  def test_it_returns_an_account_statement
    
    header = ApiBanking::AccountStatement::ReqHeader.new()
    reqBody = ApiBanking::AccountStatement::ReqBody.new()
    request = ApiBanking::AccountStatement::Request.new()
    
    header.tranID          = rand.to_s[2..6]
    header.corpID          = 'QNTGS'
    header.approverID      = 'A001'
    
    reqBody.accountNo = '408888558888'
    reqBody.transactionType = 'D'
    reqBody.fromDate = '2017-03-02'
    reqBody.toDate = '2017-03-16'
    
    request.header = header
    request.body = reqBody
    
    puts "#{self.class.name} #{ApiBanking::AccountStatement.get_statement(AccountStatementEnvironment, request)}"
    
  end  
  
end
