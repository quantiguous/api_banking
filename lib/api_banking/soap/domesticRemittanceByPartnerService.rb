module ApiBanking
  class DomesticRemittanceByPartnerService < Soap12Client
    
    SERVICE_NAMESPACE = 'http://www.quantiguous.com/services'
    SERVICE_VERSION = 1
    
    attr_accessor :request, :result

    #remit
    module Remit
      Address = Struct.new(:address1, :address2, :address3, :postalCode, :city, :stateOrProvince, :country)
      Contact = Struct.new(:mobileNo, :emailID)
      Request = Struct.new(:uniqueRequestNo, :partnerCode, :customerID, :debitAccountNo, :remitterAccountNo,
                           :remitterIFSC, :remitterName, :remitterAddress, :remitterContact, :beneficiaryName, :beneficiaryAddress, 
                           :beneficiaryContact, :beneficiaryAccountNo, :beneficiaryIFSC, :transferType, :transferCurrencyCode, :transferAmount,
                           :remitterToBeneficiaryInfo)
  
      TransactionStatus = Struct.new(:statusCode, :subStatusCode, :bankReferenceNo, :beneficiaryReferenceNo, :reason)
                         
      Result = Struct.new(:version, :uniqueResponseNo, :attemptNo, :requestReferenceNo, :transferType, :lowBalanceAlert, 
                          :transactionStatus)
    end
    
    #getStatus
    module GetStatus
      Request = Struct.new(:version, :partnerCode, :requestReferenceNo)
      TransactionStatus = Struct.new(:statusCode, :subStatusCode, :bankReferenceNo, :beneficiaryReferenceNo, :reason)
    
      Result = Struct.new(:version, :transferType, :reqTransferType, :transactionDate, :transferAmount, :transferCurrencyCode,
                        :transactionStatus)
    end
                                 
    #getBalance
    module GetBalance
      Request = Struct.new(:version, :partnerCode, :customerID, :accountNo)

      Result = Struct.new(:version, :accountCurrencyCode, :accountBalanceAmount, :lowBalanceAlert)
    end
    
    #getTransactions
    module GetTransactions
      Request = Struct.new(:version, :partnerCode, :customerID, :accountNo, :dateRange)
    
      DateRange = Struct.new(:fromDate, :toDate)    
      TransactionsArray = Struct.new(:transaction)
      Transaction = Struct.new(:transactionDateTime, :transactionType, :amount, :narrative, :referenceNo, :balance)

      Result = Struct.new(:version, :openingBalance, :numDebits, :numCredits, :closingBalance, :numTransactions, :transactionsArray)
    end
    
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
        
    def self.remit(request)
      reply = do_remote_call do |xml|
        xml.remit("xmlns:ns" => SERVICE_NAMESPACE ) do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['ns'].version SERVICE_VERSION
          xml['ns'].uniqueRequestNo request.uniqueRequestNo
          xml['ns'].partnerCode request.partnerCode
          xml['ns'].customerID request.customerID
          xml['ns'].debitAccountNo request.debitAccountNo
          xml['ns'].remitterAccountNo request.remitterAccountNo
          xml['ns'].remitterIFSC request.remitterIFSC
          xml['ns'].remitterName request.remitterName
          xml['ns'].remitterAddress do |xml|
            if request.remitterAddress.kind_of?  Remit::Address
              xml.address1 request.remitterAddress.address1
              xml.address2 request.remitterAddress.address2 unless request.remitterAddress.address2.nil?
              xml.address3 request.remitterAddress.address3 unless request.remitterAddress.address3.nil?
              xml.postalCode request.remitterAddress.postalCode unless request.remitterAddress.postalCode.nil?
              xml.city request.remitterAddress.city unless request.remitterAddress.city.nil?
              xml.stateOrProvince request.remitterAddress.stateOrProvince unless request.remitterAddress.stateOrProvince.nil?
              xml.country request.remitterAddress.country unless request.remitterAddress.country.nil?
            else
              xml.address1 request.remitterAddress
            end
          end
          xml['ns'].remitterContact do |xml|
            xml.mobileNo request.remitterContact.mobileNo unless request.remitterContact.mobileNo.nil?
            xml.emailID request.remitterContact.emailID unless request.remitterContact.emailID.nil?
          end
          xml['ns'].beneficiaryName request.beneficiaryName
          xml['ns'].beneficiaryAddress do |xml|
            if request.beneficiaryAddress.kind_of? Remit::Address
              xml.address1 request.beneficiaryAddress.address1
              xml.address2 request.beneficiaryAddress.address2 unless request.beneficiaryAddress.address2.nil?
              xml.address3 request.beneficiaryAddress.address3 unless request.beneficiaryAddress.address3.nil?
              xml.postalCode request.beneficiaryAddress.postalCode unless request.beneficiaryAddress.postalCode.nil?
              xml.city request.beneficiaryAddress.city unless request.beneficiaryAddress.city.nil?
              xml.stateOrProvince request.beneficiaryAddress.stateOrProvince unless request.beneficiaryAddress.stateOrProvince.nil?
              xml.country request.beneficiaryAddress.country unless request.beneficiaryAddress.country.nil?
            else
              xml.address1 request.beneficiaryAddress
            end
          end
          xml['ns'].beneficiaryContact do |xml|
            xml.mobileNo request.beneficiaryContact.mobileNo unless request.beneficiaryContact.mobileNo.nil?
            xml.emailID request.beneficiaryContact.emailID unless request.beneficiaryContact.emailID.nil?
          end
          xml['ns'].beneficiaryAccountNo request.beneficiaryAccountNo
          xml['ns'].beneficiaryIFSC request.beneficiaryIFSC
          xml['ns'].transferType request.transferType
          xml['ns'].transferCurrencyCode 'INR'
          xml['ns'].transferAmount request.transferAmount
          xml['ns'].remitterToBeneficiaryInfo request.remitterToBeneficiaryInfo
        end
      end  
      parse_reply(:remit, reply)
    end
    
    def self.get_status(request)
      reply = do_remote_call do |xml|
        xml.getRemittanceStatus("xmlns:ns" => SERVICE_NAMESPACE ) do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['ns'].version SERVICE_VERSION
          xml['ns'].partnerCode request.partnerCode
          xml['ns'].requestReferenceNo request.requestReferenceNo
        end
      end
      parse_reply(:getRemittanceStatus, reply)
    end
    
    def self.get_balance(request)
      reply = do_remote_call do |xml|
        xml.getBalance("xmlns:ns" => SERVICE_NAMESPACE ) do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['ns'].version SERVICE_VERSION
          xml['ns'].partnerCode request.partnerCode
          xml['ns'].customerID request.customerID
          xml['ns'].accountNo request.accountNo
        end
      end
      parse_reply(:getBalance, reply)
    end
    
    def self.get_transactions(request)
      reply = do_remote_call do |xml|
        xml.getTransactions("xmlns:ns" => SERVICE_NAMESPACE ) do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['ns'].version SERVICE_VERSION
          xml['ns'].partnerCode request.partnerCode
          xml['ns'].customerID request.customerID
          xml['ns'].accountNo request.accountNo
          xml.dateRange do |xml|
            xml.fromDate request.dateRange.fromDate unless request.dateRange.fromDate.nil?
            xml.toDate request.dateRange.toDate unless request.dateRange.toDate.nil?
          end
        end
      end
      parse_reply(:getTransactions, reply)
    end
    
    def self.parse_reply(operationName, reply)
      if reply.kind_of?Fault
        return reply
      else
        case operationName
          when :remit
            transactionStatus = Remit::TransactionStatus.new(
              content_at(reply.at_xpath('//ns:remitResponse/ns:transactionStatus/ns:statusCode', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:remitResponse/ns:transactionStatus/ns:subStatusCode', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:remitResponse/ns:transactionStatus/ns:bankReferenceNo', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:remitResponse/ns:transactionStatus/ns:beneficiaryReferenceNo', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:remitResponse/ns:transactionStatus/ns:reason', 'ns' => SERVICE_NAMESPACE))
            )
            return Remit::Result.new(
              content_at(reply.at_xpath('//ns:remitResponse/ns:version', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:remitResponse/ns:uniqueResponseNo', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:remitResponse/ns:attemptNo', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:remitResponse/ns:requestReferenceNo', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:remitResponse/ns:transferType', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:remitResponse/ns:lowBalanceAlert', 'ns' => SERVICE_NAMESPACE)),
              transactionStatus
            )
          when :getRemittanceStatus
            transactionStatus = GetStatus::TransactionStatus.new(
              content_at(reply.at_xpath('//ns:getRemittanceStatusResponse/ns:transactionStatus/ns:statusCode', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getRemittanceStatusResponse/ns:transactionStatus/ns:subStatusCode', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getRemittanceStatusResponse/ns:transactionStatus/ns:bankReferenceNo', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getRemittanceStatusResponse/ns:transactionStatus/ns:beneficiaryReferenceNo', 'ns' => SERVICE_NAMESPACE))
            )
            return GetStatus::Result.new(
              content_at(reply.at_xpath('//ns:getRemittanceStatusResponse/ns:version', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getRemittanceStatusResponse/ns:transferType', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getRemittanceStatusResponse/ns:reqTransferType', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getRemittanceStatusResponse/ns:transactionDate', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getRemittanceStatusResponse/ns:transferAmount', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getRemittanceStatusResponse/ns:transferCurrencyCode', 'ns' => SERVICE_NAMESPACE)),
              transactionStatus
            ) 
          when :getBalance
            return GetBalance::Result.new(
              content_at(reply.at_xpath('//ns:getBalanceResponse/ns:version', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getBalanceResponse/ns:accountCurrencyCode', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getBalanceResponse/ns:accountBalanceAmount', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getBalanceResponse/ns:lowBalanceAlert', 'ns' => SERVICE_NAMESPACE))
            )
          when :getTransactions
            txnsArray = Array.new
            i = 1
            numTxns = content_at(reply.at_xpath('//ns:getTransactionsResponse/ns:numTransactions', 'ns' => SERVICE_NAMESPACE)).to_i
            until i > numTxns
              txnsArray << GetTransactions::Transaction.new(
                content_at(reply.at_xpath("//ns:getTransactionsResponse/ns:transactionsArray/ns:transaction[#{i}]/ns:transactionDateTime", 'ns' => SERVICE_NAMESPACE)),
                content_at(reply.at_xpath("//ns:getTransactionsResponse/ns:transactionsArray/ns:transaction[#{i}]/ns:transactionType", 'ns' => SERVICE_NAMESPACE)),
                content_at(reply.at_xpath("//ns:getTransactionsResponse/ns:transactionsArray/ns:transaction[#{i}]/ns:amount", 'ns' => SERVICE_NAMESPACE)),
                content_at(reply.at_xpath("//ns:getTransactionsResponse/ns:transactionsArray/ns:transaction[#{i}]/ns:narrative", 'ns' => SERVICE_NAMESPACE)),
                content_at(reply.at_xpath("//ns:getTransactionsResponse/ns:transactionsArray/ns:transaction[#{i}]/ns:referenceNo", 'ns' => SERVICE_NAMESPACE)),
                content_at(reply.at_xpath("//ns:getTransactionsResponse/ns:transactionsArray/ns:transaction[#{i}]/ns:balance", 'ns' => SERVICE_NAMESPACE))
              )
              i = i + 1;
            end;
            transactionsArray = GetTransactions::TransactionsArray.new(txnsArray)
            return GetTransactions::Result.new(
              content_at(reply.at_xpath('//ns:getTransactionsResponse/ns:version', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getTransactionsResponse/ns:openingBalance', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getTransactionsResponse/ns:numDebits', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getTransactionsResponse/ns:numCredits', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getTransactionsResponse/ns:closingBalance', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getTransactionsResponse/ns:numTransactions', 'ns' => SERVICE_NAMESPACE)),
              transactionsArray
            )
        end         
      end
    end
    
    def url
      return '/DomesticRemittanceByPartnerService'
    end
  end
end
