module ApiBanking
  class FundsTransferByCustomerService2 < Soap12Client
    
    SERVICE_NAMESPACE = 'http://www.quantiguous.com/services'
    SERVICE_VERSION = 1
    
    attr_accessor :request, :result

    #transfer
    module Transfer
      Address = Struct.new(:address1, :address2, :address3, :postalCode, :city, :stateOrProvince, :country)
      Beneficiary = Struct.new(:fullName, :address, :accountNo, :accountIFSC, :mobileNo, :mmid, :beneCode)
      Request = Struct.new(:uniqueRequestNo, :appID, :customerID, :debitAccountNo, :beneficiary, :transferAmount, :transferType, :purposeCode, :remitterToBeneficiaryInfo)
    
      TransactionStatus = Struct.new(:statusCode, :subStatusCode, :bankReferenceNo, :beneficiaryReferenceNo)
      Result = Struct.new(:version, :uniqueResponseNo, :attemptNo, :transferType, :lowBalanceAlert, :transactionStatus)
    end
    
    #getStatus
    module GetStatus
      Request = Struct.new(:version, :appID, :customerID, :requestReferenceNo)
      TransactionStatus = Struct.new(:statusCode, :subStatusCode, :bankReferenceNo, :beneficiaryReferenceNo)
      Result = Struct.new(:version, :transferType, :reqTransferType, :transactionDate, :transferAmount, :transferCurrencyCode, :transactionStatus)
    end
    
    #getBalance
    module GetBalance
      Request = Struct.new(:version, :appID, :customerID, :AccountNumber)
      Result = Struct.new(:Version, :accountCurrencyCode, :accountBalanceAmount, :lowBalanceAlert)
    end
        
    def self.transfer(env, request)
      reply = do_remote_call(env) do |xml|
        xml.transfer("xmlns:ns" => SERVICE_NAMESPACE ) do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['ns'].version SERVICE_VERSION
          xml['ns'].uniqueRequestNo request.uniqueRequestNo
          xml['ns'].appID request.appID
          xml['ns'].purposeCode request.purposeCode unless request.purposeCode.nil?
          xml['ns'].customerID request.customerID
          xml['ns'].debitAccountNo request.debitAccountNo
          xml['ns'].beneficiary do  |xml|
            xml.beneficiaryCode request.beneficiary.beneCode unless request.beneficiary.beneCode.nil?
            unless request.beneficiary.fullName.nil?
              xml.beneficiaryDetail do |xml|
                xml.beneficiaryName do |xml|
                  xml.fullName request.beneficiary.fullName
                end
                xml.beneficiaryAddress do |xml|
                  if request.beneficiary.address.kind_of? Transfer::Address 
                    xml.address1 request.beneficiary.address.address1
                    xml.address2 request.beneficiary.address.address2 unless request.beneficiary.address.address2.nil?
                    xml.address3 request.beneficiary.address.address3 unless request.beneficiary.address.address3.nil?
                    xml.postalCode request.beneficiary.address.postalCode unless request.beneficiary.address.postalCode.nil?
                    xml.city request.beneficiary.address.city unless request.beneficiary.address.city.nil?
                    xml.stateOrProvince request.beneficiary.address.stateOrProvince unless request.beneficiary.address.stateOrProvince.nil?
                    xml.country request.beneficiary.address.country unless request.beneficiary.address.country.nil?
                  else
                    xml.address1 request.beneficiary.address
                  end
                end
                xml.beneficiaryContact do |xml|
                end
                xml.beneficiaryAccountNo request.beneficiary.accountNo
                xml.beneficiaryIFSC request.beneficiary.accountIFSC
              end
            end
          end
          xml.transferType request.transferType
          xml.transferCurrencyCode 'INR'
          xml.transferAmount request.transferAmount
          xml.remitterToBeneficiaryInfo request.remitterToBeneficiaryInfo
        end
      end
      
      parse_reply(:transfer, reply)
    end

    
    def self.get_status(env, request)
      reply = do_remote_call(env) do |xml|
        xml.getStatus("xmlns:ns" => SERVICE_NAMESPACE ) do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['ns'].version SERVICE_VERSION
          xml['ns'].appID request.appID
          xml['ns'].customerID request.customerID
          xml['ns'].requestReferenceNo request.requestReferenceNo
        end
      end
      parse_reply(:getStatus, reply)
    end
    
    def self.get_balance(env, request)
      reply = do_remote_call(env) do |xml|
        xml.getBalance("xmlns:ns" => SERVICE_NAMESPACE ) do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['ns'].version SERVICE_VERSION
          xml['ns'].appID request.appID
          xml['ns'].customerID request.customerID
          xml['ns'].AccountNumber request.AccountNumber
        end
      end
      parse_reply(:getBalance, reply)
    end

    private
    
    def self.uri()
        return '/fundsTransferByCustomerService2'
    end
        
    def self.parse_reply(operationName, reply)
      if reply.kind_of?Fault
        return reply
      else
        case operationName
          when :transfer
            transactionStatus = Transfer::TransactionStatus.new(
              content_at(reply.at_xpath('//ns:transferResponse/ns:transactionStatus/ns:statusCode', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:transferResponse/ns:transactionStatus/ns:subStatusCode', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:transferResponse/ns:transactionStatus/ns:bankReferenceNo', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:transferResponse/ns:transactionStatus/ns:beneficiaryReferenceNo', 'ns' => SERVICE_NAMESPACE))
            )
            return Transfer::Result.new(
              content_at(reply.at_xpath('//ns:transferResponse/ns:version', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:transferResponse/ns:uniqueResponseNo', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:transferResponse/ns:attemptNo', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:transferResponse/ns:transferType', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:transferResponse/ns:lowBalanceAlert', 'ns' => SERVICE_NAMESPACE)),
              transactionStatus
              )
          when :getStatus
            transactionStatus = GetStatus::TransactionStatus.new(
              content_at(reply.at_xpath('//ns:getStatusResponse/ns:transactionStatus/ns:statusCode', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getStatusResponse/ns:transactionStatus/ns:subStatusCode', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getStatusResponse/ns:transactionStatus/ns:bankReferenceNo', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getStatusResponse/ns:transactionStatus/ns:beneficiaryReferenceNo', 'ns' => SERVICE_NAMESPACE))
            )
            return GetStatus::Result.new(
              content_at(reply.at_xpath('//ns:getStatusResponse/ns:version', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getStatusResponse/ns:transferType', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getStatusResponse/ns:reqTransferType', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getStatusResponse/ns:transactionDate', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getStatusResponse/ns:transferAmount', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getStatusResponse/ns:transferCurrencyCode', 'ns' => SERVICE_NAMESPACE)),
              transactionStatus
            )  
          when :getBalance
            return GetBalance::Result.new(
              content_at(reply.at_xpath('//ns:getBalanceResponse/ns:Version', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getBalanceResponse/ns:accountCurrencyCode', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getBalanceResponse/ns:accountBalanceAmount', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getBalanceResponse/ns:lowBalanceAlert', 'ns' => SERVICE_NAMESPACE))
            )   
        end         
      end
    end
    
    def url
      return '/fundsTransferByCustomerService2'
    end

  end
end
