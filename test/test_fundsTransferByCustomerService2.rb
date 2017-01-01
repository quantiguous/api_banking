require 'minitest_helper'

class TestFundsTransferByCustomerService2 < Minitest::Test
  def test_fundsTransferbyCustomerService2_exists
    assert ApiBanking::FundsTransferByCustomerService2
  end

  def transfer_request
    address = ApiBanking::FundsTransferByCustomerService2::Transfer::Address.new()
    beneficiary = ApiBanking::FundsTransferByCustomerService2::Transfer::Beneficiary.new()
    request = ApiBanking::FundsTransferByCustomerService2::Transfer::Request.new()

    address.address1 = 'Mumbai'

    beneficiary.fullName = 'Quantiguous Solutions'
    beneficiary.accountNo = '00001234567890'
    beneficiary.accountIFSC = 'RBIB0123456'
    beneficiary.address = address  # can also be a string

    request.uniqueRequestNo = SecureRandom.uuid.gsub!('-','')
    request.appID = 'APP12'
    request.purposeCode = 'PC01'
    request.customerID = '000000'
    request.debitAccountNo = '00001234567890'
    request.transferType = 'NEFT'
    request.transferAmount = 20
    request.remitterToBeneficiaryInfo = 'FUND TRANSFER'

    request.beneficiary = beneficiary
    request
  end

  def test_it_gives_back_a_transfer_result
    puts "#{self.class.name} transfer: #{ApiBanking::FundsTransferByCustomerService2.transfer(FundsTransferByCustomerService2Environment, transfer_request)}"
  end

  def test_it_responds_to_callbacks_for_transfer
    callbacks = ApiBanking::Callbacks.new do |c|
      c.before_send do |r|
        puts "LOGGED REQ: [#{Time.now}] Request #{r.options}"
      end

      c.on_complete do |r|
        puts "LOGGED RESP: [#{Time.now}] Response #{r.code}"
      end
    end

    assert_output(/LOGGED REQ.*LOGGED RESP/m) do
      puts "#{self.class.name} transfer: #{ApiBanking::FundsTransferByCustomerService2.transfer(FundsTransferByCustomerService2Environment, transfer_request, callbacks)}"
    end

  end

  def test_it_gives_back_a_get_status_result

    request = ApiBanking::FundsTransferByCustomerService2::GetStatus::Request.new()

    request.appID = 'APP12'
    request.customerID = '000000'
    request.requestReferenceNo = 'SOMEREFERENCENO'

    puts "#{self.class.name} get_status: #{ApiBanking::FundsTransferByCustomerService2.get_status(FundsTransferByCustomerService2Environment, request)}"
  end

  def test_it_gives_back_a_get_balance_result

    request = ApiBanking::FundsTransferByCustomerService2::GetBalance::Request.new()

    request.appID = 'APP12'
    request.customerID = '000000'
    request.AccountNumber = '00001234567890'

    puts "#{self.class.name} get_balance: #{ApiBanking::FundsTransferByCustomerService2.get_balance(FundsTransferByCustomerService2Environment, request)}"
  end
end
