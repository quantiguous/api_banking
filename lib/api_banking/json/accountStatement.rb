module ApiBanking
  class AccountStatement < JsonClient

    SERVICE_VERSION = 1
    CODE_NO_TXN_FOUND = '8504'

    attr_accessor :request, :result

    ReqHeader = Struct.new(:corpID, :approverID)
    ReqBody = Struct.new(:accountNo, :transactionType, :fromDate, :toDate)
    Request = Struct.new(:header, :body)

    Transactions = Struct.new(:transactionDateTime, :transactionType, :amount, :narrative, :referenceNo, :balance)
    Result = Struct.new(:transactions)

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

    def self.get_statement(env, request, callbacks = nil)
      dataHash = {}
      dataHash[:Acc_Stmt_DtRng_Req] = {}
      dataHash[:Acc_Stmt_DtRng_Req][:Header] = {}
      dataHash[:Acc_Stmt_DtRng_Req][:Body] = {}

      dataHash[:Acc_Stmt_DtRng_Req][:Header][:TranID] = '00'
      dataHash[:Acc_Stmt_DtRng_Req][:Header][:Corp_ID] = request.header.corpID
      # the tags Maker_ID and Checker_ID have been removed since Schema Validation Error is returned when these are sent in the request.
      dataHash[:Acc_Stmt_DtRng_Req][:Header][:Approver_ID] = request.header.approverID

      dataHash[:Acc_Stmt_DtRng_Req][:Body][:Acc_No] = request.body.accountNo
      dataHash[:Acc_Stmt_DtRng_Req][:Body][:Tran_Type] = request.body.transactionType
      dataHash[:Acc_Stmt_DtRng_Req][:Body][:From_Dt] = request.body.fromDate
      
      dataHash[:Acc_Stmt_DtRng_Req][:Body][:Pagination_Details] = {}
      dataHash[:Acc_Stmt_DtRng_Req][:Body][:Pagination_Details][:Last_Balance] = {}

      dataHash[:Acc_Stmt_DtRng_Req][:Body][:Pagination_Details][:Last_Balance][:Amount_Value] = ''
      dataHash[:Acc_Stmt_DtRng_Req][:Body][:Pagination_Details][:Last_Balance][:Currency_Code] = ''
      dataHash[:Acc_Stmt_DtRng_Req][:Body][:Pagination_Details][:Last_Pstd_Date] = ''
      dataHash[:Acc_Stmt_DtRng_Req][:Body][:Pagination_Details][:Last_Txn_Date] = ''
      dataHash[:Acc_Stmt_DtRng_Req][:Body][:Pagination_Details][:Last_Txn_Id] = ''
      dataHash[:Acc_Stmt_DtRng_Req][:Body][:Pagination_Details][:Last_Txn_SrlNo] = ''
      
      dataHash[:Acc_Stmt_DtRng_Req][:Body][:To_Dt] = request.body.toDate

      reply = do_remote_call(env, dataHash, callbacks)

      parse_reply(:getStatement, reply)
    end

    private

    def self.parse_reply(operationName, reply)
      if reply.kind_of?Fault
        reply.code == CODE_NO_TXN_FOUND ? AccountStatement::Result.new([]) : reply
      else
        case operationName
          when :getStatement
          sortedTxnArray = Array.new
          txnArray = reply['Acc_Stmt_DtRng_Res']['Body']['transactionDetails'].sort_by { |e| parsed_datetime(e['pstdDate'])}
          txnArray.each do |txn|
            txnAmt = parsed_money(
                        txn['transactionSummary']['txnAmt']['amountValue'],
                        txn['transactionSummary']['txnAmt']['currencyCode']
                      )
            txnBalance = parsed_money(
                          txn['txnBalance']['amountValue'],
                          txn['txnBalance']['currencyCode']
                        )

            sortedTxnArray << AccountStatement::Transactions.new(
                                    parsed_datetime(txn['pstdDate']),
                                    txn['transactionSummary']['txnType'],
                                    txnAmt,
                                    txn['transactionSummary']['txnDesc'],
                                    txn['txnId'],
                                    txnBalance
                                  )
          end
          return AccountStatement::Result.new(
                    sortedTxnArray
                 )
        end
      end
    end

    def self.parsed_money(amount, currency)
      Money.from_amount(amount.to_d, currency)
    end

    def self.parsed_datetime(datetime)
      DateTime.parse(datetime)
    end
  end
end
