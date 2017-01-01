module ApiBanking
  class SinglePayment < JsonClient

    SERVICE_VERSION = 1

    attr_accessor :request, :result

    #transfer
    Remitter = Struct.new(:accountNo, :accountName, :accountIFSC, :mobileNo, :tranParticulars, :partTranRemarks)
    Beneficiary = Struct.new(:fullName, :address, :accountNo, :accountIFSC, :bankName, :bankCode, :branchCode, :email, :mobileNo, :mmid, :tranParticulars, :partTranRemarks)
    Request = Struct.new(:uniqueRequestNo, :corpID, :makerID, :checkerID, :approverID, :remitter, :beneficiary, :amount, :issueBranchCode, :modeOfPay, :remarks, :rptCode)

    Result = Struct.new(:status, :errorCode, :errorDescription)

    class << self
      attr_accessor :configuration
    end

    def self.configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    class Configuration
      attr_accessor :environment, :proxy, :timeout
    end

    def self.transfer(request, callbacks = nil)
      dataHash = {}
      dataHash[:Single_Payment_Corp_Req] = {}
      dataHash[:Single_Payment_Corp_Req][:Header] = {}
      dataHash[:Single_Payment_Corp_Req][:Body] = {}

      dataHash[:Single_Payment_Corp_Req][:Header][:TranID] = request.uniqueRequestNo
      dataHash[:Single_Payment_Corp_Req][:Header][:Corp_ID] = request.corpID
      dataHash[:Single_Payment_Corp_Req][:Header][:Maker_ID] = request.makerID
      dataHash[:Single_Payment_Corp_Req][:Header][:Checker_ID] = request.checkerID
      dataHash[:Single_Payment_Corp_Req][:Header][:Approver_ID] = request.approverID

      dataHash[:Single_Payment_Corp_Req][:Body][:Amount] = request.amount
      dataHash[:Single_Payment_Corp_Req][:Body][:Debit_Acct_No] = request.remitter.accountNo
      dataHash[:Single_Payment_Corp_Req][:Body][:Debit_Acct_Name] = request.remitter.accountName
      dataHash[:Single_Payment_Corp_Req][:Body][:Debit_IFSC] = request.remitter.accountIFSC
      dataHash[:Single_Payment_Corp_Req][:Body][:Debit_Mobile] = request.remitter.mobileNo
      dataHash[:Single_Payment_Corp_Req][:Body][:Debit_TrnParticulars] = request.remitter.tranParticulars
      dataHash[:Single_Payment_Corp_Req][:Body][:Debit_PartTrnRmks] = request.remitter.partTranRemarks

      dataHash[:Single_Payment_Corp_Req][:Body][:Ben_IFSC] = request.beneficiary.accountIFSC
      dataHash[:Single_Payment_Corp_Req][:Body][:Ben_Acct_No] = request.beneficiary.accountNo
      dataHash[:Single_Payment_Corp_Req][:Body][:Ben_Name] = request.beneficiary.fullName
      dataHash[:Single_Payment_Corp_Req][:Body][:Ben_Address] = request.beneficiary.address
      dataHash[:Single_Payment_Corp_Req][:Body][:Ben_BankName] = request.beneficiary.bankName
      dataHash[:Single_Payment_Corp_Req][:Body][:Ben_BankCd] = request.beneficiary.bankCode
      dataHash[:Single_Payment_Corp_Req][:Body][:Ben_BranchCd] = request.beneficiary.branchCode
      dataHash[:Single_Payment_Corp_Req][:Body][:Ben_Email] = request.beneficiary.email
      dataHash[:Single_Payment_Corp_Req][:Body][:Ben_Mobile] = request.beneficiary.mobileNo
      dataHash[:Single_Payment_Corp_Req][:Body][:Ben_TrnParticulars] = request.beneficiary.tranParticulars
      dataHash[:Single_Payment_Corp_Req][:Body][:Ben_PartTrnRmks] = request.beneficiary.partTranRemarks
      dataHash[:Single_Payment_Corp_Req][:Body][:Issue_BranchCd] = request.issueBranchCode
      dataHash[:Single_Payment_Corp_Req][:Body][:Mode_of_Pay] = request.modeOfPay
      dataHash[:Single_Payment_Corp_Req][:Body][:Remarks] = request.remarks
      dataHash[:Single_Payment_Corp_Req][:Body][:RptCode] = request.rptCode


      reply = do_remote_call(dataHash, callbacks)

      parse_reply(:transferResponse, reply)
    end


    private

    def self.uri()
      if self.configuration.environment.kind_of?ApiBanking::Environment::RBL::UAT
        return '/test/sb/rbl/v1/payments/corp/payment'
      else
        return '/sb/rbl/v1/payments/corp/payment'
      end
    end

    def self.parse_reply(operationName, reply)
      if reply.kind_of?Fault
        return reply
      else
        puts reply
        case operationName
          when :transferResponse
        end
      end
    end

  end
end
