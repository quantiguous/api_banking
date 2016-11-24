module ApiBanking
  class InwardRemittanceByPartnerService < Soap12Client

    SERVICE_NAMESPACE = 'http://www.quantiguous.com/services'
    SERVICE_VERSION = 1
    
    attr_accessor :request, :result
    
    #remit
    module Remit
      Name = Struct.new(:fullName)
      Address = Struct.new(:address1, :address2, :address3, :postalCode, :city, :stateOrProvince, :country)
      Contact = Struct.new(:mobileNo, :emailID)
      Identities = Struct.new(:identity)
      Identity = Struct.new(:idType, :idNumber, :idCountry, :issueDate, :expiryDate)
      Request = Struct.new(:version, :uniqueRequestNo, :partnerCode, :remitterType, :remitterName, :remitterAddress, :remitterContact, :remitterIdentities, 
                          :beneficiaryType, :beneficiaryName, :beneficiaryAddress, :beneficiaryContact, :beneficiaryIdentities, :beneficiaryAccountNo, 
                          :beneficiaryIFSC, :transferType, :transferCurrencyCode, :transferAmount, :remitterToBeneficiaryInfo, :purposeCode)
      TransactionStatus = Struct.new(:statusCode, :subStatusCode, :bankReferenceNo, :beneficiaryReferenceNo)
      ItemsForReview = Struct.new(:itemForReview)
      ItemForReview = Struct.new(:justificationCode, :justificationText, :statusCode, :reviewedOn, :reviewRemark)
      ReviewStatus = Struct.new(:reviewRequired, :itemsForReview)
      Result = Struct.new(:version, :uniqueResponseNo, :attemptNo, :transferType, :lowBalanceAlert, :transactionStatus, :reviewStatus)
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
        
    def self.remit(env, request)
      reply = do_remote_call(env) do |xml|
        xml.remit("xmlns:ns" => SERVICE_NAMESPACE ) do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['ns'].version SERVICE_VERSION
          xml['ns'].uniqueRequestNo request.uniqueRequestNo
          xml['ns'].partnerCode request.partnerCode
          xml['ns'].remitterType request.remitterType
          xml['ns'].remitterName do  |xml|
            xml.fullName request.remitterName.fullName
          end
          unless request.remitterAddress.address1.nil?
            xml.remitterAddress do |xml|
              xml.address1 request.remitterAddress.address1
              xml.address2 request.remitterAddress.address2 unless request.remitterAddress.address2.nil?
              xml.address3 request.remitterAddress.address3 unless request.remitterAddress.address3.nil?
              xml.postalCode request.remitterAddress.postalCode unless request.remitterAddress.postalCode.nil?
              xml.city request.remitterAddress.city unless request.remitterAddress.city.nil?
              xml.stateOrProvince request.remitterAddress.stateOrProvince unless request.remitterAddress.stateOrProvince.nil?
              xml.country request.remitterAddress.country unless request.remitterAddress.country.nil?
            end
          end
          xml.remitterContact do |xml|
            xml.mobileNo request.remitterContact.mobileNo unless request.remitterContact.mobileNo.nil?
            xml.mobileNo request.remitterContact.emailID unless request.remitterContact.emailID.nil?
          end
          xml.remitterIdentities do |xml|
            unless request.remitterIdentities.identity.nil?
              request.remitterIdentities.identity.each_with_index do |identity, index|
                xml.identity do |xml|
                  xml.idType request.remitterIdentities.identity[index].idType unless request.remitterIdentities.identity[index].idType.nil?
                  xml.idNumber request.remitterIdentities.identity[index].idNumber unless request.remitterIdentities.identity[index].idNumber.nil?
                  xml.idCountry request.remitterIdentities.identity[index].idCountry unless request.remitterIdentities.identity[index].idCountry.nil?
                  xml.issueDate request.remitterIdentities.identity[index].issueDate unless request.remitterIdentities.identity[index].issueDate.nil?
                  xml.expiryDate request.remitterIdentities.identity[index].expiryDate unless request.remitterIdentities.identity[index].expiryDate.nil?
                end
              end
            end
          end
          xml.beneficiaryType request.beneficiaryType
          xml['ns'].beneficiaryName do  |xml|
            xml.fullName request.beneficiaryName.fullName
          end
          unless request.beneficiaryAddress.address1.nil?
            xml.beneficiaryAddress do |xml|
              xml.address1 request.beneficiaryAddress.address1
              xml.address2 request.beneficiaryAddress.address2 unless request.beneficiaryAddress.address2.nil?
              xml.address3 request.beneficiaryAddress.address3 unless request.beneficiaryAddress.address3.nil?
              xml.postalCode request.beneficiaryAddress.postalCode unless request.beneficiaryAddress.postalCode.nil?
              xml.city request.beneficiaryAddress.city unless request.beneficiaryAddress.city.nil?
              xml.stateOrProvince request.beneficiaryAddress.stateOrProvince unless request.beneficiaryAddress.stateOrProvince.nil?
              xml.country request.beneficiaryAddress.country unless request.beneficiaryAddress.country.nil?
            end
          end
          xml.beneficiaryContact do |xml|
            xml.mobileNo request.beneficiaryContact.mobileNo unless request.beneficiaryContact.mobileNo.nil?
            xml.mobileNo request.beneficiaryContact.emailID unless request.beneficiaryContact.emailID.nil?
          end
          xml.beneficiaryIdentities do |xml|
            unless request.beneficiaryIdentities.identity.nil?
              request.beneficiaryIdentities.identity.each_with_index do |identity, index|
                xml.identity do |xml|
                  xml.idType request.beneficiaryIdentities.identity[index].idType unless request.beneficiaryIdentities.identity[index].idType.nil?
                  xml.idNumber request.beneficiaryIdentities.identity[index].idNumber unless request.beneficiaryIdentities.identity[index].idNumber.nil?
                  xml.idCountry request.beneficiaryIdentities.identity[index].idCountry unless request.beneficiaryIdentities.identity[index].idCountry.nil?
                  xml.issueDate request.beneficiaryIdentities.identity[index].issueDate unless request.beneficiaryIdentities.identity[index].issueDate.nil?
                  xml.expiryDate request.beneficiaryIdentities.identity[index].expiryDate unless request.beneficiaryIdentities.identity[index].expiryDate.nil?
                end
              end
            end
          end
          xml.beneficiaryAccountNo request.beneficiaryAccountNo
          xml.beneficiaryIFSC request.beneficiaryIFSC
          xml.transferType request.transferType
          xml.transferCurrencyCode request.transferCurrencyCode
          xml.transferAmount request.transferAmount
          xml.remitterToBeneficiaryInfo request.remitterToBeneficiaryInfo
          xml.purposeCode request.purposeCode
        end
      end
      parse_reply(:remit, reply)
    end

    private
    
    def self.uri()
      return '/InwardRemittanceByPartnerService'
    end
        
    def self.parse_reply(operationName, reply)
      if reply.kind_of?Fault
        return reply
      else
        case operationName
          when :remit
            # numItems = reply.xpath('//ns:remitResponse/ns:itemsForReview/ns:itemForReview', 'ns' => SERVICE_NAMESPACE).count
            # i = 1
            # itemsArray = Array.new
            # until i > numItems
            #   itemsArray << Remit::ItemForReview.new(
            #     content_at(reply.at_xpath("//ns:remitResponse/ns:reviewStatus/ns:/itemsForReview/ns:itemForReview[#{i}]/ns:justificationCode", 'ns' => SERVICE_NAMESPACE)),
            #     content_at(reply.at_xpath("//ns:remitResponse/ns:reviewStatus/ns:/itemsForReview/ns:itemForReview[#{i}]/ns:justificationText", 'ns' => SERVICE_NAMESPACE)),
            #     content_at(reply.at_xpath("//ns:remitResponse/ns:reviewStatus/ns:/itemsForReview/ns:itemForReview[#{i}]/ns:statusCode", 'ns' => SERVICE_NAMESPACE)),
            #     content_at(reply.at_xpath("//ns:remitResponse/ns:reviewStatus/ns:/itemsForReview/ns:itemForReview[#{i}]/ns:reviewedOn", 'ns' => SERVICE_NAMESPACE)),
            #     content_at(reply.at_xpath("//ns:remitResponse/ns:reviewStatus/ns:/itemsForReview/ns:itemForReview[#{i}]/ns:reviewRemark", 'ns' => SERVICE_NAMESPACE))
            #   )
            #   i = i + 1
            # end
            # itemsForReview = Remit::ItemsForReview.new(itemsArray)
            transactionStatus = Remit::TransactionStatus.new(
              content_at(reply.at_xpath('//ns:remitResponse/ns:transactionStatus/ns:statusCode', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:remitResponse/ns:transactionStatus/ns:subStatusCode', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:remitResponse/ns:transactionStatus/ns:bankReferenceNo', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:remitResponse/ns:transactionStatus/ns:beneficiaryReferenceNo', 'ns' => SERVICE_NAMESPACE))
            )
            reviewStatus = Remit::ReviewStatus.new(
              content_at(reply.at_xpath('//ns:remitResponse/ns:reviewStatus/ns:reviewRequired', 'ns' => SERVICE_NAMESPACE)),
              nil#itemsForReview
            )
            return Remit::Result.new(
              content_at(reply.at_xpath('//ns:remitResponse/ns:version', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:remitResponse/ns:uniqueResponseNo', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:remitResponse/ns:attemptNo', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:remitResponse/ns:transferType', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:remitResponse/ns:lowBalanceAlert', 'ns' => SERVICE_NAMESPACE)),
              transactionStatus,
              reviewStatus           
            )
        end         
      end
    end
    
    def url
      return '/InwardRemittanceByPartnerService'
    end

  end
end
