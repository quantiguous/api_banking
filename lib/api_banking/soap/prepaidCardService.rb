module ApiBanking
  class PrepaidCardService < Soap12Client
    
    SERVICE_NAMESPACE = 'http://www.quantiguous.com/services'
    SERVICE_VERSION = 1
    
    attr_accessor :request, :result

    #addBeneficiary
    module AddBeneficiary
      Request = Struct.new(:version, :uniqueRequestNo, :appID, :mobileNo, :beneficiaryName, :beneficiaryAccountNo, :beneficiaryIFSC)
    
      Result = Struct.new(:version, :uniqueResponseNo, :beneficiaryID)
    end
    
    #getBalance
    module GetBalance
      Request = Struct.new(:version, :appID, :mobileNo)
    
      Result = Struct.new(:version, :currencyCode, :cardBalance)
    end
    
    #getBeneficiaries
    module GetBeneficiaries
      Request = Struct.new(:version, :appID, :mobileNo, :numBeneficiaries)

      Beneficiary = Struct.new(:beneficiaryName, :beneficiaryAccountNo, :beneficiaryIFSC)
      BeneficiariesArray = Struct.new(:beneficiary)
      Result = Struct.new(:version, :numBeneficiaries, :beneficiariesArray)
    end
    
    #getCustomerDetail
    module GetCustomerDetail
      Request = Struct.new(:version, :appID, :mobileNo)

      Result = Struct.new(:version, :customerEmail, :customerPrefferedName, :programCode, :productCode, :productDisplayName, :productCustomerCareNo)
    end
    
    #getTransactions
    module GetTransactions
      Request = Struct.new(:version, :appID, :mobileNo, :numTransactions)

      Transaction = Struct.new(:transactionID, :recordDate, :transactionCode, :transactionType, :currencyCode, :amount, :narrative)
      TransactionsArray = Struct.new(:transaction)
      Result = Struct.new(:version, :numTransactions, :transactionsArray)
    end
    
    #payToAccount
    module PayToAccount
      Request = Struct.new(:version, :uniqueRequestNo, :appID, :mobileNo, :encryptedPIN, :transferType, :beneficiaryName, :beneficiaryAccountNo, :beneficiaryIFSC, :transferAmount, :remitterToBeneficiaryInfo)
    
      Result = Struct.new(:version, :uniqueResponseNo, :transferType, :bankReferenceNo, :serviceCharge)
    end
    
    #payToContact
    module PayToContact
      Request = Struct.new(:version, :uniqueRequestNo, :appID, :mobileNo, :encryptedPIN, :contactName, :contactMobileNo, :transferAmount)
    
      Result = Struct.new(:version, :appID, :uniqueResponseNo, :serviceCharge)
    end
    
    #topUp
    module TopUp
      Request = Struct.new(:version, :uniqueRequestNo, :appID, :mobileNo, :encryptedPIN, :billerID, :subscriberID, :topupAmount)
    
      Result = Struct.new(:version, :uniqueResponseNo, :serviceCharge, :debitReferenceNo, :billerReferenceNo)
    end
    
    #verifyPIN
    module VerifyPIN
      Request = Struct.new(:version, :appID, :mobileNo, :pinBlock)
    
      Result = Struct.new(:version)
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
    
    def self.addBeneficiary(env, request)
      reply = do_remote_call(env) do |xml|
        xml.addBeneficiary("xmlns:ns" => SERVICE_NAMESPACE ) do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['ns'].version SERVICE_VERSION
          xml['ns'].uniqueRequestNo request.uniqueRequestNo
          xml['ns'].appID request.appID
          xml['ns'].mobileNo request.mobileNo
          xml['ns'].beneficiaryName request.beneficiaryName
          xml['ns'].beneficiaryAccountNo request.beneficiaryAccountNo
          xml['ns'].beneficiaryIFSC request.beneficiaryIFSC
        end
      end
      parse_reply(:addBeneficiary, reply)
    end
    
    def self.getBalance(env, request)
      reply = do_remote_call(env) do |xml|
        xml.getBalance("xmlns:ns" => SERVICE_NAMESPACE ) do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['ns'].version SERVICE_VERSION
          xml['ns'].appID request.appID
          xml['ns'].mobileNo request.mobileNo
        end
      end
      parse_reply(:getBalance, reply)
    end
    
    def self.getBeneficiaries(env, request)
      reply = do_remote_call(env) do |xml|
        xml.getBeneficiaries("xmlns:ns" => SERVICE_NAMESPACE ) do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['ns'].version SERVICE_VERSION
          xml['ns'].appID request.appID
          xml['ns'].mobileNo request.mobileNo
          xml['ns'].numBeneficiaries request.numBeneficiaries
        end
      end
      parse_reply(:getBeneficiaries, reply)
    end
    
    def self.getCustomerDetail(env, request)
      reply = do_remote_call(env) do |xml|
        xml.getCustomerDetail("xmlns:ns" => SERVICE_NAMESPACE ) do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['ns'].version SERVICE_VERSION
          xml['ns'].appID request.appID
          xml['ns'].mobileNo request.mobileNo
        end
      end
      parse_reply(:getCustomerDetail, reply)
    end
    
    def self.getTransactions(env, request)
      reply = do_remote_call(env) do |xml|
        xml.getTransactions("xmlns:ns" => SERVICE_NAMESPACE ) do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['ns'].version SERVICE_VERSION
          xml['ns'].appID request.appID
          xml['ns'].mobileNo request.mobileNo
          xml['ns'].numTransactions request.numTransactions
        end
      end
      parse_reply(:getTransactions, reply)
    end
    
    def self.payToAccount(env, request)
      reply = do_remote_call(env) do |xml|
        xml.payToAccount("xmlns:ns" => SERVICE_NAMESPACE ) do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['ns'].version SERVICE_VERSION
          xml['ns'].uniqueRequestNo request.uniqueRequestNo
          xml['ns'].appID request.appID
          xml['ns'].mobileNo request.mobileNo
          xml['ns'].encryptedPIN request.encryptedPIN
          xml['ns'].transferType request.transferType
          xml['ns'].beneficiaryName request.beneficiaryName
          xml['ns'].beneficiaryAccountNo request.beneficiaryAccountNo
          xml['ns'].beneficiaryIFSC request.beneficiaryIFSC
          xml['ns'].transferAmount request.transferAmount
          xml['ns'].remitterToBeneficiaryInfo request.remitterToBeneficiaryInfo
        end
      end
      parse_reply(:payToAccount, reply)
    end

    def self.payToContact(env, request)
      reply = do_remote_call(env) do |xml|
        xml.payToContact("xmlns:ns" => SERVICE_NAMESPACE ) do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['ns'].version SERVICE_VERSION
          xml['ns'].uniqueRequestNo request.uniqueRequestNo
          xml['ns'].appID request.appID
          xml['ns'].mobileNo request.mobileNo
          xml['ns'].encryptedPIN request.encryptedPIN
          xml['ns'].contactName request.contactName
          xml['ns'].contactMobileNo request.contactMobileNo
          xml['ns'].transferAmount request.transferAmount
        end
      end
      parse_reply(:payToContact, reply)
    end

    def self.topUp(env, request)
      reply = do_remote_call(env) do |xml|
        xml.topUp("xmlns:ns" => SERVICE_NAMESPACE ) do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['ns'].version SERVICE_VERSION
          xml['ns'].uniqueRequestNo request.uniqueRequestNo
          xml['ns'].appID request.appID
          xml['ns'].mobileNo request.mobileNo
          xml['ns'].encryptedPIN request.encryptedPIN
          xml['ns'].billerID request.billerID
          xml['ns'].subscriberID request.subscriberID
          xml['ns'].topupAmount request.topupAmount
        end
      end
      parse_reply(:topUp, reply)
    end

    def self.verifyPIN(env, request)
      reply = do_remote_call(env) do |xml|
        xml.verifyPIN("xmlns:ns" => SERVICE_NAMESPACE ) do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['ns'].version SERVICE_VERSION
          xml['ns'].appID request.appID
          xml['ns'].mobileNo request.mobileNo
          xml['ns'].pinBlock request.pinBlock
        end
      end
      parse_reply(:verifyPIN, reply)
    end
    
    private

    def self.uri()
      return '/PrepaidCardService'
    end

    def self.parse_reply(operationName, reply)
      if reply.kind_of?Fault
        return reply
      else
        case operationName
          when :addBeneficiary
            return AddBeneficiary::Result.new(
              content_at(reply.at_xpath('//ns:addBeneficiaryResponse/ns:version', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:addBeneficiaryResponse/ns:uniqueResponseNo', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:addBeneficiaryResponse/ns:beneficiaryID', 'ns' => SERVICE_NAMESPACE)),
              )
          when :getBalance
            return GetBalance::Result.new(
              content_at(reply.at_xpath('//ns:getBalanceResponse/ns:version', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getBalanceResponse/ns:currencyCode', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getBalanceResponse/ns:cardBalance', 'ns' => SERVICE_NAMESPACE))
            )  
          when :getBeneficiaries
            beneArray = Array.new 
            i = 1
            numBene = content_at(reply.xpath('//ns:getBeneficiariesResponse/ns:numBeneficiaries', 'ns' => SERVICE_NAMESPACE)).to_i
            until i > numBene
              beneArray << GetBeneficiaries::Beneficiary.new(
                content_at(reply.at_xpath("//ns:getBeneficiariesResponse/ns:beneficiariesArray/ns:beneficiary[#{i}]/ns:beneficiaryName", 'ns' => SERVICE_NAMESPACE)),
                content_at(reply.at_xpath("//ns:getBeneficiariesResponse/ns:beneficiariesArray/ns:beneficiary[#{i}]/ns:beneficiaryAccountNo", 'ns' => SERVICE_NAMESPACE)),
                content_at(reply.at_xpath("//ns:getBeneficiariesResponse/ns:beneficiariesArray/ns:beneficiary[#{i}]/ns:beneficiaryIFSC", 'ns' => SERVICE_NAMESPACE))
              )
              i = i + 1;
            end
            beneficiariesArray = GetBeneficiaries::BeneficiariesArray.new(beneArray)
            return GetBeneficiaries::Result.new(
              content_at(reply.at_xpath('//ns:getBeneficiariesResponse/ns:version', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getBeneficiariesResponse/ns:numBeneficiaries', 'ns' => SERVICE_NAMESPACE)),
              beneficiariesArray
            )
          when :getCustomerDetail
            return GetCustomerDetail::Result.new(
              content_at(reply.at_xpath('//ns:getCustomerDetailResponse/ns:version', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getCustomerDetailResponse/ns:customerEmail', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getCustomerDetailResponse/ns:customerPrefferedName', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getCustomerDetailResponse/ns:programCode', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getCustomerDetailResponse/ns:productCode', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getCustomerDetailResponse/ns:productDisplayName', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getCustomerDetailResponse/ns:productCustomerCareNo', 'ns' => SERVICE_NAMESPACE))
            )   
          when :getTransactions
            txnArray = Array.new 
            i = 1
            numTxns = content_at(reply.at_xpath("//ns:getTransactionsResponse/ns:numTransactions", 'ns' => SERVICE_NAMESPACE)).to_i
            until i > numTxns
              txnArray << GetTransactions::Transaction.new(
                content_at(reply.at_xpath("//ns:getTransactionsResponse/ns:transactionsArray/ns:transaction[#{i}]/ns:transactionID", 'ns' => SERVICE_NAMESPACE)),
                content_at(reply.at_xpath("//ns:getTransactionsResponse/ns:transactionsArray/ns:transaction[#{i}]/ns:recordDate", 'ns' => SERVICE_NAMESPACE)),
                content_at(reply.at_xpath("//ns:getTransactionsResponse/ns:transactionsArray/ns:transaction[#{i}]/ns:transactionCode", 'ns' => SERVICE_NAMESPACE)),
                content_at(reply.at_xpath("//ns:getTransactionsResponse/ns:transactionsArray/ns:transaction[#{i}]/ns:transactionType", 'ns' => SERVICE_NAMESPACE)),
                content_at(reply.at_xpath("//ns:getTransactionsResponse/ns:transactionsArray/ns:transaction[#{i}]/ns:currencyCode", 'ns' => SERVICE_NAMESPACE)),
                content_at(reply.at_xpath("//ns:getTransactionsResponse/ns:transactionsArray/ns:transaction[#{i}]/ns:amount", 'ns' => SERVICE_NAMESPACE)),
                content_at(reply.at_xpath("//ns:getTransactionsResponse/ns:transactionsArray/ns:transaction[#{i}]/ns:narrative", 'ns' => SERVICE_NAMESPACE))
              )
              i = i + 1;
            end
            transactionsArray = GetTransactions::TransactionsArray.new(txnArray)
            return GetTransactions::Result.new(
              content_at(reply.at_xpath('//ns:getTransactionsResponse/ns:version', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getTransactionsResponse/ns:numTransactions', 'ns' => SERVICE_NAMESPACE)),
              transactionsArray
            )
          when :payToAccount
            return PayToAccount::Result.new(
              content_at(reply.at_xpath('//ns:payToAccountResponse/ns:version', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:payToAccountResponse/ns:uniqueResponseNo', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:payToAccountResponse/ns:transferType', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:payToAccountResponse/ns:bankReferenceNo', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:payToAccountResponse/ns:serviceCharge', 'ns' => SERVICE_NAMESPACE))
            )
          when :payToContact
            return PayToContact::Result.new(
              content_at(reply.at_xpath('//ns:payToContactResponse/ns:version', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:payToContactResponse/ns:uniqueResponseNo', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:payToContactResponse/ns:appID', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:payToContactResponse/ns:serviceCharge', 'ns' => SERVICE_NAMESPACE))
            )
          when :topUp
            return TopUp::Result.new(
              content_at(reply.at_xpath('//ns:topUpResponse/ns:version', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:topUpResponse/ns:uniqueResponseNo', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:topUpResponse/ns:serviceCharge', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:topUpResponse/ns:debitReferenceNo', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:topUpResponse/ns:billerReferenceNo', 'ns' => SERVICE_NAMESPACE))
            )
          when :verifyPIN
            return VerifyPIN::Result.new(
              content_at(reply.at_xpath('//ns:verifyPINResponse/ns:version', 'ns' => SERVICE_NAMESPACE))
            )
        end         
      end
    end

    def url
      return '/PrepaidCardService'
    end

  end
end