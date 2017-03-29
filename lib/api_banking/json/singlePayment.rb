module ApiBanking
  class SinglePayment < JsonClient

    SERVICE_VERSION = 1

    attr_accessor :request, :result

    ReqHeader = Struct.new(:tranID, :corpID, :approverID)
    Remitter = Struct.new(:accountNo, :accountName, :accountIFSC, :mobileNo)
    Beneficiary = Struct.new(:accountIFSC, :accountNo, :fullName, :address, :email, :mobileNo)
    ReqBody = Struct.new(:amount, :remitter, :beneficiary, :modeOfPay, :remarks)
    Request = Struct.new(:header, :body)

    Result = Struct.new(:statusCode, :bankReferenceNo, :transferType)

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

    def self.transfer(env, request, callbacks = nil)
      dataHash = {}
      dataHash[:Single_Payment_Corp_Req] = {}
      dataHash[:Single_Payment_Corp_Req][:Header] = {}
      dataHash[:Single_Payment_Corp_Req][:Body] = {}

      dataHash[:Single_Payment_Corp_Req][:Header][:TranID] = request.header.tranID
      dataHash[:Single_Payment_Corp_Req][:Header][:Corp_ID] = request.header.corpID
      dataHash[:Single_Payment_Corp_Req][:Header][:Maker_ID] = ''
      dataHash[:Single_Payment_Corp_Req][:Header][:Checker_ID] = ''
      dataHash[:Single_Payment_Corp_Req][:Header][:Approver_ID] = request.header.approverID

      dataHash[:Single_Payment_Corp_Req][:Body][:Amount] = request.body.amount
      dataHash[:Single_Payment_Corp_Req][:Body][:Debit_Acct_No] = request.body.remitter.accountNo
      dataHash[:Single_Payment_Corp_Req][:Body][:Debit_Acct_Name] = request.body.remitter.accountName
      dataHash[:Single_Payment_Corp_Req][:Body][:Debit_IFSC] = request.body.remitter.accountIFSC
      dataHash[:Single_Payment_Corp_Req][:Body][:Debit_Mobile] = request.body.remitter.mobileNo

      dataHash[:Single_Payment_Corp_Req][:Body][:Ben_IFSC] = request.body.beneficiary.accountIFSC
      dataHash[:Single_Payment_Corp_Req][:Body][:Ben_Acct_No] = request.body.beneficiary.accountNo
      dataHash[:Single_Payment_Corp_Req][:Body][:Ben_Name] = request.body.beneficiary.fullName
      dataHash[:Single_Payment_Corp_Req][:Body][:Ben_Address] = request.body.beneficiary.address
      dataHash[:Single_Payment_Corp_Req][:Body][:Ben_BankName] = request.body.beneficiary.accountIFSC[0..3]
      dataHash[:Single_Payment_Corp_Req][:Body][:Ben_Email] = request.body.beneficiary.email
      dataHash[:Single_Payment_Corp_Req][:Body][:Ben_Mobile] = request.body.beneficiary.mobileNo
      dataHash[:Single_Payment_Corp_Req][:Body][:Mode_of_Pay] = request.body.modeOfPay
      dataHash[:Single_Payment_Corp_Req][:Body][:Remarks] = request.body.remarks

      reply = do_remote_call(env, dataHash, callbacks)

      parse_reply(reply, request.body.modeOfPay)
    end


    private

    def self.parse_reply(reply, transferType)
      if reply.kind_of?Fault
        reply
      else
        SinglePayment::Result.new(
          reply['Single_Payment_Corp_Resp']['Header']['Status'],
          reply['Single_Payment_Corp_Resp']['Body']['UTRNo'],
          transferType
        )
      end
    end

  end
end
