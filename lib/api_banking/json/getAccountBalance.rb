module ApiBanking
  class GetAccountBalance < JsonClient

    SERVICE_VERSION = 1

    attr_accessor :request, :result

    ReqHeader = Struct.new(:corpID, :approverID)
    ReqBody = Struct.new(:accountNo)
    Request = Struct.new(:header, :body)

    Result = Struct.new(:balanceAmount)

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

    def self.get_account_balance(env, request, callbacks = nil)
      dataHash = {}
      dataHash[:getAccountBalanceReq] = {}
      dataHash[:getAccountBalanceReq][:Header] = {}
      dataHash[:getAccountBalanceReq][:Body] = {}

      dataHash[:getAccountBalanceReq][:Header][:TranID] = '00'
      dataHash[:getAccountBalanceReq][:Header][:Corp_ID] = request.header.corpID
      # the tags Maker_ID and Checker_ID have been removed since Schema Validation Error is returned when these are sent in the request.
      dataHash[:getAccountBalanceReq][:Header][:Approver_ID] = request.header.approverID

      dataHash[:getAccountBalanceReq][:Body][:AcctId] = request.body.accountNo

      reply = do_remote_call(env, dataHash, callbacks)

      parse_reply(reply)
    end

    private

    def self.parse_reply(reply)
      if reply.kind_of?Fault
        reply
      else
        balAmt = parsed_money(reply['getAccountBalanceRes']['Body']['BalAmt']['amountValue'], 'INR')
        GetAccountBalance::Result.new(balAmt)
      end
    end

    def self.parsed_money(amount, currency)
      Money.from_amount(amount.to_f, currency)
    end
  end
end
