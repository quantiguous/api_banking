module ApiBanking
  class AccountStatement < JsonClient

    SERVICE_VERSION = 1

    attr_accessor :request, :result

    ReqHeader = Struct.new(:tranID, :corpID, :approverID)
    ReqBody = Struct.new(:accountNo, :tranType, :fromDate, :paginationDetails, :toDate)
    Request = Struct.new(:header, :body)

    AccountBalances = Struct.new(:acid, :availableBalance, :branchId, :currencyCode, :fFDBalance, :floatingBalance, :ledgerBalance, :userDefinedBalance)
    Transactions = Struct.new(:transactionDateTime, :transactionType, :amount, :narrative, :referenceNo, :balance)
    Result = Struct.new(:accountBalances, :transactionDetails)

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

      dataHash[:Acc_Stmt_DtRng_Req][:Header][:TranID] = request.header.tranID
      dataHash[:Acc_Stmt_DtRng_Req][:Header][:Corp_ID] = request.header.corpID
      dataHash[:Acc_Stmt_DtRng_Req][:Header][:Approver_ID] = request.header.approverID

      dataHash[:Acc_Stmt_DtRng_Req][:Body][:Acc_No] = request.body.accountNo
      dataHash[:Acc_Stmt_DtRng_Req][:Body][:Tran_Type] = request.body.tranType
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
        return reply
      else
        case operationName
          when :getStatement
            
          availableBalance = parsed_money(
                              reply['Acc_Stmt_DtRng_Res']['Body']['accountBalances']['availableBalance']['amountValue'], 
                              reply['Acc_Stmt_DtRng_Res']['Body']['accountBalances']['availableBalance']['currencyCode']
                            )
          fFDBalance = parsed_money(
                        reply['Acc_Stmt_DtRng_Res']['Body']['accountBalances']['fFDBalance']['amountValue'],
                        reply['Acc_Stmt_DtRng_Res']['Body']['accountBalances']['fFDBalance']['currencyCode']
                      )
          floatingBalance = parsed_money(
                              reply['Acc_Stmt_DtRng_Res']['Body']['accountBalances']['floatingBalance']['amountValue'],
                              reply['Acc_Stmt_DtRng_Res']['Body']['accountBalances']['floatingBalance']['currencyCode']
                            )
          ledgerBalance = parsed_money(
                            reply['Acc_Stmt_DtRng_Res']['Body']['accountBalances']['ledgerBalance']['amountValue'],
                            reply['Acc_Stmt_DtRng_Res']['Body']['accountBalances']['ledgerBalance']['currencyCode']
                          )
          userDefinedBalance = parsed_money(
                                reply['Acc_Stmt_DtRng_Res']['Body']['accountBalances']['userDefinedBalance']['amountValue'],
                                reply['Acc_Stmt_DtRng_Res']['Body']['accountBalances']['userDefinedBalance']['currencyCode']
                              )
          accountBalances = AccountStatement::AccountBalances.new(
                              reply['Acc_Stmt_DtRng_Res']['Body']['accountBalances']['acid'],
                              availableBalance,
                              reply['Acc_Stmt_DtRng_Res']['Body']['accountBalances']['branchId'],
                              reply['Acc_Stmt_DtRng_Res']['Body']['accountBalances']['currencyCode'],
                              fFDBalance,
                              floatingBalance,
                              ledgerBalance,
                              userDefinedBalance
                            )
          sortedTxnArray = Array.new
          txnArray = reply['Acc_Stmt_DtRng_Res']['Body']['transactionDetails'].sort_by { |e| DateTime.parse(e['pstdDate'])}
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
                    accountBalances,
                    sortedTxnArray
                 )
        end
      end
    end

    def self.parsed_money(amount, currency)
      Money.new(amount, currency)
    end

    def self.parsed_datetime(datetime)
      DateTime.parse(datetime)
    end
  end
end
