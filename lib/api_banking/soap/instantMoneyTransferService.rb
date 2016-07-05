module ApiBanking
  class InstantMoneyTransferService < SoapClient
    
    SERVICE_NAMESPACE = 'http://www.quantiguous.com/services'
    SERVICE_VERSION = 1
    
    attr_accessor :request, :result

    #transfer
    module InitiateTransfer
      Request = Struct.new(:uniqueRequestNo, :appID, :customerID, :beneficiaryMobileNo, :transferAmount, :passCode, :remitterToBeneficiaryInfo)
      Result = Struct.new(:uniqueResponseNo, :initiateTransferResult)
      TransferResult = Struct.new(:bankReferenceNo, :imtReferenceNo)
    end

    module AddBeneficiary
      Request = Struct.new(:uniqueRequestNo, :appID, :customerID, :beneficiaryMobileNo, :beneficiaryName, :beneficiaryAddress)
      Address = Struct.new(:addressLine, :cityName, :postalCode)

      Result = Struct.new(:uniqueResponseNo)
    end
    
    module DeleteBeneficiary
      Request = Struct.new(:uniqueRequestNo, :appID, :customerID, :beneficiaryMobileNo)

      Result = Struct.new(:uniqueResponseNo)
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
        
    def self.transfer(request)
      reply = do_remote_call do |xml|
        xml.initiateTransfer("xmlns:ns" => SERVICE_NAMESPACE ) do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['ns'].version SERVICE_VERSION
          xml['ns'].uniqueRequestNo request.uniqueRequestNo
          xml['ns'].appID request.appID
          xml['ns'].customerID request.customerID
          xml['ns'].beneficiaryMobileNo request.beneficiaryMobileNo
          xml['ns'].transferAmount request.transferAmount
          xml['ns'].passCode request.passCode
          xml['ns'].remitterToBeneficiaryInfo request.remitterToBeneficiaryInfo
        end
      end
      
      parse_reply(:initiateTransfer, reply)
    end

    def self.add_beneficiary(request)
      reply = do_remote_call do |xml|
        xml.addBeneficiary("xmlns:ns" => SERVICE_NAMESPACE ) do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['ns'].version SERVICE_VERSION
          xml['ns'].uniqueRequestNo request.uniqueRequestNo
          xml['ns'].appID request.appID
          xml['ns'].customerID request.customerID
          xml['ns'].beneficiaryMobileNo request.beneficiaryMobileNo
          xml['ns'].beneficiaryName request.beneficiaryName
          xml['ns'].beneficiaryAddress do  |xml|
            if request.beneficiaryAddress.kind_of? AddBeneficiary::Address 
              xml.addressLine request.beneficiaryAddress.addressLine
              xml.cityName request.beneficiaryAddress.cityName unless request.beneficiaryAddress.cityName.nil?
              xml.postalCode request.beneficiaryAddress.postalCode unless request.beneficiaryAddress.postalCode.nil?
            else
              xml.addressLine request.beneficiaryAddress
            end
          end
        end
      end
      
      parse_reply(:addBeneficiary, reply)
    end

    def self.delete_beneficiary(request)
      reply = do_remote_call do |xml|
        xml.addBeneficiary("xmlns:ns" => SERVICE_NAMESPACE ) do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['ns'].version SERVICE_VERSION
          xml['ns'].uniqueRequestNo request.uniqueRequestNo
          xml['ns'].appID request.appID
          xml['ns'].customerID request.customerID
          xml['ns'].beneficiaryMobileNo request.beneficiaryMobileNo
        end
      end
      
      parse_reply(:deleteBeneficiary, reply)
    end
  
    private
 
    def self.parse_reply(operationName, reply)
      if reply.kind_of?Fault
        return reply
      else
        puts reply
        case operationName
          when :initiateTransfer
          transferResult = InitiateTransfer::TransferResult.new(
            content_at(reply.at_xpath('//ns:initiateTransferResponse/ns:initiateTransferResult/ns:bankReferenceNo', 'ns' => SERVICE_NAMESPACE)),
            content_at(reply.at_xpath('//ns:initiateTransferResponse/ns:initiateTransferResult/ns:imtReferenceNo', 'ns' => SERVICE_NAMESPACE))
          )
          return InitiateTransfer::Result.new(
            content_at(reply.at_xpath('//ns:initiateTransferResponse/ns:uniqueResponseNo', 'ns' => SERVICE_NAMESPACE)),
            transferResult
            )
          when :addBeneficiary
          return AddBeneficiary::Result.new(
            content_at(reply.at_xpath('//ns:addBeneficiaryResponse/ns:uniqueResponseNo', 'ns' => SERVICE_NAMESPACE)),
            )
          when :deleteBeneficiary
          return DeleteBeneficiary::Result.new(
            content_at(reply.at_xpath('//ns:deleteBeneficiaryResponse/ns:uniqueResponseNo', 'ns' => SERVICE_NAMESPACE)),
            )
        end
      end
    end

  end
end
