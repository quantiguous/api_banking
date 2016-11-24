module ApiBanking
  class VirtualCardManagementService < Soap12Client
    
    SERVICE_NAMESPACE = 'http://www.quantiguous.com/services'
    SERVICE_VERSION = 1
    
    attr_accessor :request, :result

    #blockCard
    module BlockCard
      Request = Struct.new(:version, :uniqueRequestNo, :appID, :userUID, :emailID, :password)
    
      Result = Struct.new(:version, :uniqueResponseNo)
    end
    
    #getCardDetail
    module GetCardDetail
      Request = Struct.new(:version, :appID, :cardUID, :emailID, :password)
    
      Result = Struct.new(:cardUID, :cardNo, :issueDate, :expiryMonth, :expiryYear, :cardHolderName, :cardKind, :cardName, :cardDescription, :cardImageSmall, :cardImageMedium, :cardImageLarge, :securePasscode)
    end
    
    #registerCard
    module RegisterCard
      Address = Struct.new(:addressLine1, :addressLine2, :city, :state, :country, :postalCode)
      Request = Struct.new(:version, :uniqueRequestNo, :appID, :title, :firstName, :lastName, :preferredName, :mobileNo, :gender, :nationality, :birthDate, :address, :emailID, :password)
    
      Result = Struct.new(:version, :uniqueResponseNo, :userUID, :cardUID, :cardNo, :issueDate, :expiryMonth, :expiryYear, :cardHolderName, :cardKind, :cardName, :cardDescription, :cardImageSmall, :cardImageMedium, :cardImageLarge)
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

    def self.registerCard(env, request)
      reply = do_remote_call(env) do |xml|
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
          xml['ns'].birthDate request.birthDate
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
          xml['ns'].emailID request.emailID
          xml['ns'].password request.password
        end
      end
      
      parse_reply(:registerCard, reply)
    end
    
    def self.blockCard(env, request)
      reply = do_remote_call(env) do |xml|
        xml.blockCard("xmlns:ns" => SERVICE_NAMESPACE ) do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['ns'].version SERVICE_VERSION
          xml['ns'].uniqueRequestNo request.uniqueRequestNo
          xml['ns'].appID request.appID
          xml['ns'].userUID request.userUID
          xml['ns'].emailID request.emailID
          xml['ns'].password request.password
        end
      end
      parse_reply(:blockCard, reply)
    end
    
    def self.getCardDetail(env, request)
      reply = do_remote_call(env) do |xml|
        xml.getCardDetail("xmlns:ns" => SERVICE_NAMESPACE ) do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['ns'].version SERVICE_VERSION
          xml['ns'].appID request.appID
          xml['ns'].cardUID request.cardUID
          xml['ns'].emailID request.emailID
          xml['ns'].password request.password
        end
      end
      parse_reply(:getCardDetail, reply)
    end

    private

    def self.uri()
        return '/VirtualCardManagementService'
    end

    def self.parse_reply(operationName, reply)
      if reply.kind_of?Fault
        return reply
      else
        case operationName
          when :registerCard
            return RegisterCard::Result.new(
              content_at(reply.at_xpath('//ns:registerCardResponse/ns:version', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:registerCardResponse/ns:uniqueResponseNo', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:registerCardResponse/ns:userUID', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:registerCardResponse/ns:cardUID', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:registerCardResponse/ns:cardNo', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:registerCardResponse/ns:issueDate', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:registerCardResponse/ns:expiryMonth', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:registerCardResponse/ns:expiryYear', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:registerCardResponse/ns:cardHolderName', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:registerCardResponse/ns:cardKind', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:registerCardResponse/ns:cardName', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:registerCardResponse/ns:cardDescription', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:registerCardResponse/ns:cardImageSmall', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:registerCardResponse/ns:cardImageMedium', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:registerCardResponse/ns:cardImageLarge', 'ns' => SERVICE_NAMESPACE))
              )
          when :blockCard
            return LoadCard::Result.new(
              content_at(reply.at_xpath('//ns:loadCardResponse/ns:version', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:loadCardResponse/ns:uniqueResponseNo', 'ns' => SERVICE_NAMESPACE))
            )  
          when :getCardDetail
            return GetCardDetail::Result.new(
              content_at(reply.at_xpath('//ns:getCardDetailResponse/ns:cardUID', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getCardDetailResponse/ns:cardNo', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getCardDetailResponse/ns:issueDate', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getCardDetailResponse/ns:expiryMonth', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getCardDetailResponse/ns:expiryYear', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getCardDetailResponse/ns:cardHolderName', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getCardDetailResponse/ns:cardKind', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getCardDetailResponse/ns:cardName', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getCardDetailResponse/ns:cardDescription', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getCardDetailResponse/ns:cardImageSmall', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getCardDetailResponse/ns:cardImageMedium', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getCardDetailResponse/ns:cardImageLarge', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getCardDetailResponse/ns:securePasscode', 'ns' => SERVICE_NAMESPACE))
            )   
        end         
      end
    end

    def url
      return '/VirtualCardManagementService'
    end

  end
end
