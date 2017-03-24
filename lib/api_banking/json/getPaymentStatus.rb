module ApiBanking
  class GetPaymentStatus < JsonClient

    SERVICE_VERSION = 1

    attr_accessor :request, :result

    ReqHeader = Struct.new(:corpID, :approverID)
    ReqBody = Struct.new(:referenceNo)
    Request = Struct.new(:header, :body)

    Result = Struct.new(:statusCode, :bankReferenceNo)

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

    def self.get_status(env, request, callbacks = nil)
      dataHash = {}
      dataHash[:get_Single_Payment_Status_Corp_Req] = {}
      dataHash[:get_Single_Payment_Status_Corp_Req][:Header] = {}
      dataHash[:get_Single_Payment_Status_Corp_Req][:Body] = {}

      dataHash[:get_Single_Payment_Status_Corp_Req][:Header][:TranID] = '00'
      dataHash[:get_Single_Payment_Status_Corp_Req][:Header][:Corp_ID] = request.header.corpID
      # the tags Maker_ID and Checker_ID have been removed since Schema Validation Error is returned when these are sent in the request.
      dataHash[:get_Single_Payment_Status_Corp_Req][:Header][:Maker_ID] = ''
      dataHash[:get_Single_Payment_Status_Corp_Req][:Header][:Checker_ID] = ''
      dataHash[:get_Single_Payment_Status_Corp_Req][:Header][:Approver_ID] = request.header.approverID

      dataHash[:get_Single_Payment_Status_Corp_Req][:Body][:OrgTransactionID] = request.body.referenceNo

      reply = do_remote_call(env, dataHash, callbacks)
      
      puts dataHash

      parse_reply(reply)
    end

    private

    def self.parse_reply(reply)
      if reply.kind_of?Fault
        reply
      else
        GetPaymentStatus::Result.new(
          reply['get_Single_Payment_Status_Corp_Res']['Body']['TXNSTATUS'],
          reply['get_Single_Payment_Status_Corp_Res']['Body']['UTRNO']
        )
      end
    end
  end
end
