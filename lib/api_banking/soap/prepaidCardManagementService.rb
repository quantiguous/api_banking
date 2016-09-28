module ApiBanking
  class PrepaidCardManagementService < SoapClient
    
    SERVICE_NAMESPACE = 'http://www.quantiguous.com/services'
    SERVICE_VERSION = 1
    
    attr_accessor :request, :result

    #blockCard
    module BlockCard
      Request = Struct.new(:version, :uniqueRequestNo, :appID, :mobileNo)
    
      Result = Struct.new(:version, :uniqueResponseNo)
    end
    
    #loadCard
    module LoadCard
      Request = Struct.new(:version, :uniqueRequestNo, :appID, :customerID, :debitAccountNo, :mobileNo, :loadAmount)
    
      Result = Struct.new(:version, :uniqueResponseNo)
    end
    
    #registerCard
    module RegisterCard
      IDDocument = Struct.new(:documentType, :documentNo, :countryOfIssue)
      Address = Struct.new(:addressLine1, :addressLine2, :city, :state, :country, :postalCode)
      Request = Struct.new(:version, :uniqueRequestNo, :appID, :title, :firstName, :lastName, :preferredName, :mobileNo, :gender, :nationality, :birthDate, :idDocument, :address, :proxyCardNumber, :productCode)

      Result = Struct.new(:version, :uniqueResponseNo)
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
        
    def self.registerCard(request)
      reply = do_remote_call do |xml|
        xml.registerCard("xmlns:ns" => SERVICE_NAMESPACE ) do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['ns'].version SERVICE_VERSION
          xml['ns'].uniqueRequestNo request.uniqueRequestNo
          xml['ns'].appID request.appID
          xml['ns'].title request.title
          xml['ns'].firstName request.firstName
          xml['ns'].lastName request.lastName
          xml['ns'].preferredName request.preferredName
          xml['ns'].mobileNo request.mobileNo
          xml['ns'].gender request.gender
          xml['ns'].nationality request.nationality
          xml['ns'].birthDate request.birthDate if Date.parse(request.birthDate).is_a?(Date)
          xml['ns'].idDocument do  |xml|
            xml.documentType request.idDocument.documentType
            xml.documentNo request.idDocument.countryOfIssue
            xml.countryOfIssue request.idDocument.countryOfIssue
          end
          xml['ns'].address do  |xml|
            if request.address.kind_of? RegisterCard::Address 
              xml.addressLine1 request.address.addressLine1
              xml.addressLine2 request.address.addressLine2
              xml.city request.address.city
              xml.state request.address.state
              xml.country request.address.country
              xml.postalCode request.address.postalCode
            else
              xml.address1 request.address
            end
          end
          xml['ns'].proxyCardNumber request.proxyCardNumber
          xml['ns'].productCode request.productCode unless request.productCode.nil?
        end
      end
      
      parse_reply(:registerCard, reply)
    end

    
    def self.loadCard(request)
      reply = do_remote_call do |xml|
        xml.loadCard("xmlns:ns" => SERVICE_NAMESPACE ) do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['ns'].version SERVICE_VERSION
          xml['ns'].uniqueRequestNo request.uniqueRequestNo
          xml['ns'].appID request.appID
          xml['ns'].customerID request.customerID
          xml['ns'].debitAccountNo request.debitAccountNo
          xml['ns'].mobileNo request.mobileNo
          xml['ns'].loadAmount request.loadAmount
        end
      end
      parse_reply(:loadCard, reply)
    end
    
    def self.blockCard(request)
      reply = do_remote_call do |xml|
        xml.blockCard("xmlns:ns" => SERVICE_NAMESPACE ) do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['ns'].version SERVICE_VERSION
          xml['ns'].uniqueRequestNo request.uniqueRequestNo
          xml['ns'].appID request.appID
          xml['ns'].mobileNo request.mobileNo
        end
      end
      parse_reply(:blockCard, reply)
    end

    private

    def self.uri()
        return '/PrepaidCardManagementService'
    end

    def self.parse_reply(operationName, reply)
      if reply.kind_of?Fault
        return reply
      else
        case operationName
          when :registerCard
            return RegisterCard::Result.new(
              content_at(reply.at_xpath('//ns:registerCardResponse/ns:version', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:registerCardResponse/ns:uniqueResponseNo', 'ns' => SERVICE_NAMESPACE))
              )
          when :loadCard
            return LoadCard::Result.new(
              content_at(reply.at_xpath('//ns:loadCardResponse/ns:version', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:loadCardResponse/ns:uniqueResponseNo', 'ns' => SERVICE_NAMESPACE))
            )  
          when :blockCard
            return BlockCard::Result.new(
              content_at(reply.at_xpath('//ns:blockCardResponse/ns:version', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:blockCardResponse/ns:uniqueResponseNo', 'ns' => SERVICE_NAMESPACE))
            )   
        end         
      end
    end

    def url
      return '/PrepaidCardManagementService'
    end

  end
end
