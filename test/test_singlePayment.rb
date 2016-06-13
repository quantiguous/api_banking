require 'minitest_helper'

class TestSinglePayment < Minitest::Test

  def test_it_gives_back_a_transfer_result
    
    remitter = ApiBanking::SinglePayment::Remitter.new()
    beneficiary = ApiBanking::SinglePayment::Beneficiary.new()
    request = ApiBanking::SinglePayment::Request.new()
    
    request.uniqueRequestNo = rand.to_s[2..6]
    request.corpID          = 'DSPBR'
    request.makerID         = 'M001'
    request.checkerID       = 'C001'
    request.approverID      = 'A001'
    
    request.amount           = '100'
    request.modeOfPay        = 'NEFT'
    request.remarks          = 'Self Transfer'
    request.issueBranchCode  = 'IssueBranchCd'
    request.rptCode          = ''

    remitter.accountNo        = '1000110010007511'
    remitter.accountName      = 'TEJU MAHTO'
    remitter.accountIFSC      = 'RBLB1122123'
    remitter.mobileNo         = '9820659408'
    remitter.tranParticulars  = 'TO QUANTIGUOUS'
    remitter.partTranRemarks  = 'FEES'
    
    beneficiary.accountIFSC      = 'CBIN0R10001'
    beneficiary.accountNo        = '1006211030035980'
    beneficiary.fullName         = 'Quantiguous'
    beneficiary.bankName         = ''
    beneficiary.bankCode         = 'BenBankCd'
    beneficiary.branchCode       = 'BenBranchCd'
    beneficiary.address          = 'some address'
    beneficiary.email            = 'BenEmail'
    beneficiary.mobileNo         = '9820659408'
    beneficiary.tranParticulars  = 'FROM'
    beneficiary.partTranRemarks  = 'FEES'
    
    
    request.remitter = remitter
    request.beneficiary = beneficiary
    
    puts "#{self.class.name} #{ApiBanking::SinglePayment.transfer(request)}"
    
  end  
  
end
