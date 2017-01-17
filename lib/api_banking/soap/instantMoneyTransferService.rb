module ApiBanking
  class InstantMoneyTransferService < Soap12Client

    SERVICE_NAMESPACE = 'http://www.quantiguous.com/services'
    SERVICE_VERSION = 1

    attr_accessor :request, :result

    module AddBeneficiary
      Request = Struct.new(:uniqueRequestNo, :appID, :customerID, :beneficiaryMobileNo, :beneficiaryName, :beneficiaryAddress)
      Address = Struct.new(:addressLine, :cityName, :postalCode)

      Result = Struct.new(:uniqueResponseNo)
    end

    module CancelTransfer
      Request = Struct.new(:uniqueRequestNo, :appID, :customerID, :initiateTransferRequestNo, :reasonToCancel)
      Result = Struct.new(:uniqueResponseNo, :cancelResult)
      CancelResult = Struct.new(:imtReferenceNo, :bankReferenceNo)
    end

    module DeleteBeneficiary
      Request = Struct.new(:uniqueRequestNo, :appID, :customerID, :beneficiaryMobileNo)

      Result = Struct.new(:uniqueResponseNo)
    end

    module GetBeneficiaries
      Request = Struct.new(:uniqueRequestNo, :appID, :customerID, :dateRange, :numBeneficiaries)

      DateRange = Struct.new(:fromDate, :toDate)
      Beneficiary = Struct.new(:beneficiaryName, :beneficiaryMobileNo, :registrationDate, :addressLine, :postalCode)
      BeneficiariesArray = Struct.new(:beneficiary)

      Result = Struct.new(:numBeneficiaries, :beneficiariesArray)
    end

    #transfer
    module InitiateTransfer
      Request = Struct.new(:uniqueRequestNo, :appID, :customerID, :beneficiaryMobileNo, :transferAmount, :passCode, :remitterToBeneficiaryInfo)
      Result = Struct.new(:uniqueResponseNo, :initiateTransferResult)
      TransferResult = Struct.new(:bankReferenceNo, :imtReferenceNo)
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

    def self.transfer(env, request, callbacks = nil)
      reply = do_remote_call(env, callbacks) do |xml|
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

    def self.add_beneficiary(env, request, callbacks = nil)
      reply = do_remote_call(env, callbacks) do |xml|
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

    def self.delete_beneficiary(env, request, callbacks = nil)
      reply = do_remote_call(env, callbacks) do |xml|
        xml.deleteBeneficiary("xmlns:ns" => SERVICE_NAMESPACE ) do
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

    def self.get_beneficiaries(env, request, callbacks = nil)
      reply = do_remote_call(env, callbacks) do |xml|
        xml.getBeneficiaries("xmlns:ns" => SERVICE_NAMESPACE ) do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['ns'].version SERVICE_VERSION
          xml['ns'].appID request.appID
          xml['ns'].customerID request.customerID
          xml.dateRange do |xml|
            xml.fromDate request.dateRange.fromDate unless request.dateRange.fromDate.nil?
            xml.toDate request.dateRange.toDate unless request.dateRange.toDate.nil?
          end
          xml['ns'].numBeneficiaries request.numBeneficiaries
        end
      end
      parse_reply(:getBeneficiaries, reply)
    end

    def self.cancel_transfer(env, request, callbacks = nil)
      reply = do_remote_call(env, callbacks) do |xml|
        xml.cancelTransfer("xmlns:ns" => SERVICE_NAMESPACE ) do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['ns'].version SERVICE_VERSION
          xml['ns'].uniqueRequestNo request.uniqueRequestNo
          xml['ns'].appID request.appID
          xml['ns'].customerID request.customerID
          xml['ns'].initiateTransferRequestNo request.initiateTransferRequestNo
          xml['ns'].reasonToCancel request.reasonToCancel
        end
      end

      parse_reply(:cancelTransfer, reply)
    end

    private

    def self.parse_reply(operationName, reply)
      if reply.kind_of?Fault
        return reply
      else
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
          when :getBeneficiaries
            beneficiariesArray = Array.new
            i = 1
            numBeneficiaries = content_at(reply.at_xpath('//ns:getBeneficiariesResponse/ns:numBeneficiaries', 'ns' => SERVICE_NAMESPACE)).to_i
            until i > numBeneficiaries
              beneficiariesArray << GetBeneficiaries::Beneficiary.new(
                content_at(reply.at_xpath("//ns:getBeneficiariesResponse/ns:beneficiariesArray/ns:beneficiary[#{i}]/ns:beneficiaryName", 'ns' => SERVICE_NAMESPACE)),
                content_at(reply.at_xpath("//ns:getBeneficiariesResponse/ns:beneficiariesArray/ns:beneficiary[#{i}]/ns:beneficiaryMobileNo", 'ns' => SERVICE_NAMESPACE)),
                content_at(reply.at_xpath("//ns:getBeneficiariesResponse/ns:beneficiariesArray/ns:beneficiary[#{i}]/ns:registrationDate", 'ns' => SERVICE_NAMESPACE)),
                content_at(reply.at_xpath("//ns:getBeneficiariesResponse/ns:beneficiariesArray/ns:beneficiary[#{i}]/ns:addressLine", 'ns' => SERVICE_NAMESPACE)),
                content_at(reply.at_xpath("//ns:getBeneficiariesResponse/ns:beneficiariesArray/ns:beneficiary[#{i}]/ns:postalCode", 'ns' => SERVICE_NAMESPACE))
              )
              i = i + 1;
            end;
            beneArray = GetBeneficiaries::BeneficiariesArray.new(beneficiariesArray)
            return GetBeneficiaries::Result.new(
              content_at(reply.at_xpath('//ns:getBeneficiariesResponse/ns:numBeneficiaries', 'ns' => SERVICE_NAMESPACE)),
              beneArray
            )
          when :cancelTransfer
            cancelResult = CancelTransfer::CancelResult.new(
              content_at(reply.at_xpath('//ns:cancelTransferResponse/ns:cancelResult/ns:imtReferenceNo', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:cancelTransferResponse/ns:cancelResult/ns:bankReferenceNo', 'ns' => SERVICE_NAMESPACE))
            )
            return CancelTransfer::Result.new(
              content_at(reply.at_xpath('//ns:cancelTransferResponse/ns:uniqueResponseNo', 'ns' => SERVICE_NAMESPACE)),
              cancelResult
            )
        end
      end
    end

  end
end
