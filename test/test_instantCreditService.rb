require 'minitest_helper'

class InstantCreditService < Minitest::Test

  def test_it_gives_back_a_pay_now_result

    invoiceDetail = ApiBanking::InstantCreditService::PayNow::InvoiceDetail.new()
    request = ApiBanking::InstantCreditService::PayNow::Request.new()
    
    request.uniqueRequestNo = SecureRandom.uuid.gsub!('-','')
    request.appID = 'app1212'
    request.supplierCode = 'abc'
    request.customerID = '2424'
    
    invoiceDetail.invoiceNo = '12123'
    invoiceDetail.invoiceDate = '2016-02-12'
    invoiceDetail.dueDate = '2016-09-12'
    invoiceDetail.invoiceAmount = 100
    
    request.invoiceDetail = invoiceDetail
    
    request.discountedAmount = 80
    request.feeAmount = 20
    
    puts "#{self.class.name} #{ApiBanking::InstantCreditService.pay_now(request)}"

  end

  def test_it_gives_back_a_get_status_result

    request = ApiBanking::InstantCreditService::GetStatus::Request.new()

    request.appID = 'app1212'
    request.customerID = '2424'
    request.requestReferenceNo = 'QG00000001003'

    puts "#{self.class.name} : #{ApiBanking::InstantCreditService.get_status(request)}"
  end
  
end