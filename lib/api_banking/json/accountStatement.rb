module ApiBanking
  class AccountStatement < JsonClient

    SERVICE_VERSION = 1

    attr_accessor :request, :result

    ReqHeader = Struct.new(:tranID, :corpID, :approverID)
    LastBalance = Struct.new(:amountValue, :currencyCode)
    PaginationDetails = Struct.new(:lastBalance, :lastPostedDate, :lastTxnDate, :lastTxnID, :lastTxnSrlNo)
    ReqBody = Struct.new(:accountNo, :tranType, :fromDate, :paginationDetails, :toDate)
    Request = Struct.new(:header, :body)

    RepHeader = Struct.new(:tranID, :corpID, :makerID, :checkerID, :approverID, :status, :errorCode, :errorDescription)
    Balances = Struct.new(:amountValue, :currencyCode)
    AccountBalances = Struct.new(:acid, :availableBalance, :branchId, :currencyCode, :fFDBalance, :floatingBalance, :ledgerBalance, :userDefinedBalance)
    TransactionSummary = Struct.new(:instrumentId, :txnAmt, :txnDate, :txnDesc, :txnType)
    TransactionDetails = Struct.new(:pstdDate, :transactionSummary, :txnBalance, :txnCat, :txnId, :txnSrlNo, :valueDate)
    RepBody = Struct.new(:accountBalances, :transactionDetails)
    Result = Struct.new(:header, :body)

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

      dataHash[:Acc_Stmt_DtRng_Req][:Body][:Pagination_Details][:Last_Balance][:Amount_Value] = request.body.paginationDetails.lastBalance.amountValue unless request.body.paginationDetails.nil?
      dataHash[:Acc_Stmt_DtRng_Req][:Body][:Pagination_Details][:Last_Balance][:Currency_Code] = request.body.paginationDetails.lastBalance.currencyCode unless request.body.paginationDetails.nil?
      dataHash[:Acc_Stmt_DtRng_Req][:Body][:Pagination_Details][:Last_Pstd_Date] = request.body.paginationDetails.lastPostedDate unless request.body.paginationDetails.nil?
      dataHash[:Acc_Stmt_DtRng_Req][:Body][:Pagination_Details][:Last_Txn_Date] = request.body.paginationDetails.lastTxnDate unless request.body.paginationDetails.nil?
      dataHash[:Acc_Stmt_DtRng_Req][:Body][:Pagination_Details][:Last_Txn_Id] = request.body.paginationDetails.lastTxnID unless request.body.paginationDetails.nil?
      dataHash[:Acc_Stmt_DtRng_Req][:Body][:Pagination_Details][:Last_Txn_SrlNo] = request.body.paginationDetails.lastTxnSrlNo unless request.body.paginationDetails.nil?

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
          header = AccountStatement::RepHeader.new(reply['Acc_Stmt_DtRng_Res']['Header']['TranID'], 
                                                   reply['Acc_Stmt_DtRng_Res']['Header']['TranID'],
                                                   reply['Acc_Stmt_DtRng_Res']['Header']['Corp_ID'],
                                                   reply['Acc_Stmt_DtRng_Res']['Header']['Approver_ID'],
                                                   reply['Acc_Stmt_DtRng_Res']['Header']['Status'],
                                                   reply['Acc_Stmt_DtRng_Res']['Header']['Error_Cde'],
                                                   reply['Acc_Stmt_DtRng_Res']['Header']['Error_Desc']
                                                  )

          availableBalance = AccountStatement::Balances.new(
                              reply['Acc_Stmt_DtRng_Res']['Body']['accountBalances']['availableBalance']['amountValue'],
                              reply['Acc_Stmt_DtRng_Res']['Body']['accountBalances']['availableBalance']['currencyCode']
                            )
          fFDBalance = AccountStatement::Balances.new(
                        reply['Acc_Stmt_DtRng_Res']['Body']['accountBalances']['fFDBalance']['amountValue'],
                        reply['Acc_Stmt_DtRng_Res']['Body']['accountBalances']['fFDBalance']['currencyCode']
                      )
          floatingBalance = AccountStatement::Balances.new(
                              reply['Acc_Stmt_DtRng_Res']['Body']['accountBalances']['floatingBalance']['amountValue'],
                              reply['Acc_Stmt_DtRng_Res']['Body']['accountBalances']['floatingBalance']['currencyCode']
                            )
          ledgerBalance = AccountStatement::Balances.new(
                            reply['Acc_Stmt_DtRng_Res']['Body']['accountBalances']['ledgerBalance']['amountValue'],
                            reply['Acc_Stmt_DtRng_Res']['Body']['accountBalances']['ledgerBalance']['currencyCode']
                          )
          userDefinedBalance = AccountStatement::Balances.new(
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
          transactionDetails = Array.new
          (0..reply['Acc_Stmt_DtRng_Res']['Body']['transactionDetails'].count-1).each do |i|
            txnAmt = AccountStatement::Balances.new(
                        reply['Acc_Stmt_DtRng_Res']['Body']['transactionDetails'][i]['transactionSummary']['txnAmt']['amountValue'],
                        reply['Acc_Stmt_DtRng_Res']['Body']['transactionDetails'][i]['transactionSummary']['txnAmt']['currencyCode']
                      )
            txnBalance = AccountStatement::Balances.new(
                          reply['Acc_Stmt_DtRng_Res']['Body']['transactionDetails'][i]['txnBalance']['amountValue'],
                          reply['Acc_Stmt_DtRng_Res']['Body']['transactionDetails'][i]['txnBalance']['currencyCode']
                        )
            transactionSummary = AccountStatement::TransactionSummary.new(
                                  reply['Acc_Stmt_DtRng_Res']['Body']['transactionDetails'][i]['transactionSummary']['instrumentId'],
                                  txnAmt,
                                  reply['Acc_Stmt_DtRng_Res']['Body']['transactionDetails'][i]['transactionSummary']['txnDate'],
                                  reply['Acc_Stmt_DtRng_Res']['Body']['transactionDetails'][i]['transactionSummary']['txnDesc'],
                                  reply['Acc_Stmt_DtRng_Res']['Body']['transactionDetails'][i]['transactionSummary']['txnType']
                                )
            transactionDetails << AccountStatement::TransactionDetails.new(
                                  reply['Acc_Stmt_DtRng_Res']['Body']['transactionDetails'][i]['pstdDate'],
                                  transactionSummary,
                                  txnBalance,
                                  reply['Acc_Stmt_DtRng_Res']['Body']['transactionDetails'][i]['txnCat'],
                                  reply['Acc_Stmt_DtRng_Res']['Body']['transactionDetails'][i]['txnId'],
                                  reply['Acc_Stmt_DtRng_Res']['Body']['transactionDetails'][i]['txnSrlNo'],
                                  reply['Acc_Stmt_DtRng_Res']['Body']['transactionDetails'][i]['valueDate']
                              )
          end
          body = AccountStatement::RepBody.new(
                    accountBalances,
                    transactionDetails
                 )
          return AccountStatement::Result.new(header, body)            
        end
      end
    end
  end
end
