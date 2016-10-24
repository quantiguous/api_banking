module ApiBanking
  class NotificationService < Soap12Client
    
    SERVICE_NAMESPACE = 'http://www.quantiguous.com/services'
    SERVICE_VERSION = 1
    
    attr_accessor :request, :result

    #getTopics
    module GetTopics
      ReqCriteria = Struct.new(:topicGroup, :subscriber)
      Subscriber = Struct.new(:customerID, :subscribed, :unsubscribed)
      Request = Struct.new(:version, :appID, :criteria)
    
      TopicsArray = Struct.new(:topic)
      Topic = Struct.new(:topicName, :topicDisplayName, :topicGroup, :needsSubscription, :notifyByEmail, :notifyBySMS, :canBeBatched, :subscriptionProvider, :criteriaDefinitionArray, :subscription)
      CriteriaDefinitionArray = Struct.new(:criteriaDefinition)
      CriteriaDefinition = Struct.new(:name, :valueDataType, :condition)
      Subscription = Struct.new(:subscribedAt, :criteriaArray)
      CriteriaArray = Struct.new(:criteria)
      RepCriteria = Struct.new(:name, :value)
      Value = Struct.new(:decimalValue, :dateValue, :stringValue)
      Result = Struct.new(:version, :topicsArray)
    end

    #setSubscription
    module SetSubscription
      Request = Struct.new(:version, :appID, :topicName, :notifyByEmail, :notifyBySMS, :subscriber, :criteriaArray)
      Subscriber = Struct.new(:customerID, :accountNo, :contact)
      Contact =  Struct.new(:emailID, :mobileNo)
      CriteriaArray = Struct.new(:criteria)
      Criteria = Struct.new(:name, :value)
      Value = Struct.new(:decimalValue, :dateValue, :stringValue)
      Result = Struct.new(:version, :subscribedAt)
    end

    #deleteSubscription
    module DeleteSubscription
      Request = Struct.new(:version, :appID, :topicName, :subscriber)
      Subscriber = Struct.new(:customerID, :accountNo)
      Result = Struct.new(:version, :subscribedAt)
    end

    #sendMessage
    module SendMessage
      Request = Struct.new(:version, :appID, :topicName, :recipient, :mergeVarArray, :criteriaArray, :referenceNo, :sendAt, :attachment)
      Recipient = Struct.new(:subscriber, :guest)
      Subscriber = Struct.new(:customerID, :accountNo, :contact)
      Contact = Struct.new(:emailID, :mobileNo)
      Guest = Struct.new(:emailID, :mobileNo)
      MergeVarArray = Struct.new(:mergeVar)
      MergeVar = Struct.new(:name, :content)
      Content = Struct.new(:stringContent, :dateContent, :dateTimeContent, :decimalContent)
      CriteriaArray = Struct.new(:criteria)
      Criteria = Struct.new(:name, :value)
      Value = Struct.new(:decimalValue, :dateValue, :stringValue)
      Attachment = Struct.new(:filePath, :contentType)
      Result = Struct.new(:version, :uniqueResponseNo)
    end

    #dispatchMessage
    module DispatchMessage
      Request = Struct.new(:version, :appID, :topicName, :recipient, :criteriaArray, :message, :referenceNo, :sendAt)
      Recipient = Struct.new(:subscriber, :guest)
      Subscriber = Struct.new(:customerID, :accountNo, :contact)
      Contact = Struct.new(:emailID, :mobileNo)
      Guest = Struct.new(:emailID, :mobileNo)
      CriteriaArray = Struct.new(:criteria)
      Criteria = Struct.new(:name, :value)
      Value = Struct.new(:decimalValue, :dateValue, :stringValue)
      Message = Struct.new(:smsText, :email)
      Email = Struct.new(:subject, :bodyContent, :attachment)
      Attachment = Struct.new(:filePath, :contentType)
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
        
    def self.getTopics(request)
      reply = do_remote_call do |xml|
        xml.getTopics("xmlns:ns" => SERVICE_NAMESPACE ) do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['ns'].version SERVICE_VERSION
          xml['ns'].appID request.appID
          unless request.criteria.nil?
            xml['ns'].criteria do  |xml|
              xml.topicGroup request.criteria.topicGroup unless request.criteria.topicGroup.nil?
              unless request.criteria.subscriber.nil?
                xml.subscriber do |xml|
                  xml.customerID request.criteria.subscriber.customerID unless request.criteria.subscriber.customerID.nil?
                  xml.subscribed request.criteria.subscriber.subscribed unless request.criteria.subscriber.subscribed.nil?
                  xml.unsubscribed request.criteria.subscriber.unsubscribed unless request.criteria.subscriber.unsubscribed.nil?
                end
              end
            end
          end
        end  
      end
      parse_reply(:getTopics, reply)
    end

    def self.setSubscription(request)
      reply = do_remote_call do |xml|
        xml.setSubscription("xmlns:ns" => SERVICE_NAMESPACE ) do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['ns'].version SERVICE_VERSION
          xml['ns'].appID request.appID
          xml['ns'].topicName request.topicName
          xml['ns'].notifyByEmail request.notifyByEmail
          xml['ns'].notifyBySMS request.notifyBySMS
          xml['ns'].subscriber do |xml|
            xml.customerID request.subscriber.customerID
            xml.accountNo request.subscriber.accountNo
            unless request.subscriber.contact.nil?
              xml.contact do |xml|
                xml.emailID request.subscriber.contact.emailID unless request.subscriber.contact.emailID.nil? 
                xml.mobileNo request.subscriber.contact.mobileNo unless request.subscriber.contact.mobileNo.nil? 
              end
            end
          end
          unless request.criteriaArray.nil?
            xml['ns'].criteriaArray do |xml|
              unless request.criteriaArray.criteria.nil?
                xml.criteria do |xml|
                  xml.name request.criteriaArray.criteria.name
                  xml.value do |xml|
                    xml.decimalValue request.criteriaArray.criteria.value.decimalValue unless request.criteriaArray.criteria.value.decimalValue.nil? 
                    xml.dateValue request.criteriaArray.criteria.value.dateValue unless request.criteriaArray.criteria.value.dateValue.nil? 
                    xml.stringValue request.criteriaArray.criteria.value.stringValue unless request.criteriaArray.criteria.value.stringValue.nil? 
                  end
                end
              end
            end
          end
        end  
      end
      parse_reply(:setSubscription, reply)
    end

    def self.deleteSubscription(request)
      reply = do_remote_call do |xml|
        xml.deleteSubscription("xmlns:ns" => SERVICE_NAMESPACE ) do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['ns'].version SERVICE_VERSION
          xml['ns'].appID request.appID
          xml['ns'].topicName request.topicName
          unless request.subscriber.nil?
            xml.subscriber do |xml|
              xml.customerID request.subscriber.customerID
              xml.accountNo request.subscriber.accountNo unless request.subscriber.accountNo.nil?
            end
          end
        end  
      end
      parse_reply(:deleteSubscription, reply)
    end

    def self.sendMessage(request)
      reply = do_remote_call do |xml|
        xml.sendMessage("xmlns:ns" => SERVICE_NAMESPACE ) do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['ns'].version SERVICE_VERSION
          xml['ns'].appID request.appID
          xml['ns'].topicName request.topicName
          xml.recipient do |xml|
            xml.subscriber do |xml|
              xml.customerID request.recipient.subscriber.customerID
              xml.accountNo request.recipient.subscriber.accountNo unless request.recipient.subscriber.accountNo.nil?
              unless request.recipient.subscriber.contact.nil?
                xml.contact do |xml|
                  xml.emailID request.recipient.subscriber.contact.emailID unless request.recipient.subscriber.contact.emailID.nil?
                  xml.mobileNo request.recipient.subscriber.contact.mobileNo unless request.recipient.subscriber.contact.mobileNo.nil?
                end
              end
            end
            unless request.recipient.guest.nil?
              xml.guest do |xml|
                xml.emailID request.recipient.guest.emailID unless request.recipient.guest.emailID.nil?
                xml.mobileNo request.recipient.guest.mobileNo unless request.recipient.guest.mobileNo.nil?
              end
            end
          end
          unless request.mergeVarArray.nil?
            xml.mergeVarArray do |xml|
              xml.mergeVar do |xml|
                xml.name request.mergeVarArray.mergeVar.name
                xml.content do |xml|
                  xml.stringContent request.mergeVarArray.mergeVar.content.stringContent unless request.mergeVarArray.mergeVar.content.stringContent.nil?
                  xml.dateContent request.mergeVarArray.mergeVar.content.dateContent unless request.mergeVarArray.mergeVar.content.dateContent.nil?
                  xml.dateTimeContent request.mergeVarArray.mergeVar.content.dateTimeContent unless request.mergeVarArray.mergeVar.content.dateTimeContent.nil?
                  xml.decimalContent request.mergeVarArray.mergeVar.content.decimalContent unless request.mergeVarArray.mergeVar.content.decimalContent.nil?
                end
              end
            end
          end
          unless request.criteriaArray.nil?
            xml.criteriaArray do |xml|
              xml.criteria do |xml|
                xml.name request.criteriaArray.criteria.name
                xml.value do |xml|
                  xml.decimalValue request.criteriaArray.criteria.value.decimalValue unless request.criteriaArray.criteria.value.decimalValue.nil?
                  xml.dateValue request.criteriaArray.criteria.value.dateValue unless request.criteriaArray.criteria.value.dateValue.nil?
                  xml.stringValue request.criteriaArray.criteria.value.stringValue unless request.criteriaArray.criteria.value.stringValue.nil?
                end
              end
            end
          end
          xml['ns'].referenceNo request.referenceNo unless request.referenceNo.nil?
          xml['ns'].sendAt request.sendAt unless request.sendAt.nil?
          unless request.attachment.nil?
            xml['ns'].attachment do |xml|
              xml.filePath request.attachment.filePath
              xml.contentType request.attachment.contentType
            end
          end
        end  
      end
      parse_reply(:sendMessage, reply)
    end

    def self.dispatchMessage(request)
      reply = do_remote_call do |xml|
        xml.dispatchMessage("xmlns:ns" => SERVICE_NAMESPACE ) do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['ns'].version SERVICE_VERSION
          xml['ns'].appID request.appID
          xml['ns'].topicName request.topicName
          xml.recipient do |xml|
            xml.subscriber do |xml|
              xml.customerID request.recipient.subscriber.customerID
              xml.accountNo request.recipient.subscriber.accountNo unless request.recipient.subscriber.accountNo.nil?
              unless request.recipient.subscriber.contact.nil?
                xml.contact do |xml|
                  xml.emailID request.recipient.subscriber.contact.emailID unless request.recipient.subscriber.contact.emailID.nil?
                  xml.mobileNo request.recipient.subscriber.contact.mobileNo unless request.recipient.subscriber.contact.mobileNo.nil?
                end
              end
            end
            unless request.recipient.guest.nil?
              xml.guest do |xml|
                xml.emailID request.recipient.guest.emailID unless request.recipient.guest.emailID.nil?
                xml.mobileNo request.recipient.guest.mobileNo unless request.recipient.guest.mobileNo.nil?
              end
            end
          end
          unless request.criteriaArray.nil?
            xml.criteriaArray do |xml|
              xml.criteria do |xml|
                xml.name request.criteriaArray.criteria.name
                xml.value do |xml|
                  xml.decimalValue request.criteriaArray.criteria.value.decimalValue unless request.criteriaArray.criteria.value.decimalValue.nil?
                  xml.dateValue request.criteriaArray.criteria.value.dateValue unless request.criteriaArray.criteria.value.dateValue.nil?
                  xml.stringValue request.criteriaArray.criteria.value.stringValue unless request.criteriaArray.criteria.value.stringValue.nil?
                end
              end
            end
          end
          xml.message do |xml|
            xml.smsText request.message.smsText unless request.message.smsText.nil?
            unless request.message.email.nil?
              xml.email do |xml|
                xml.subject request.message.email.subject unless request.message.email.subject.nil?
                xml.bodyContent request.message.email.bodyContent unless request.message.email.bodyContent.nil?
                unless request.message.email.attachment.nil?
                  xml.attachment do |xml|
                    xml.filePath request.attachment.filePath
                    xml.contentType request.attachment.contentType
                  end
                end
              end
            end
          end
          xml['ns'].referenceNo request.referenceNo unless request.referenceNo.nil?
          xml['ns'].sendAt request.sendAt unless request.sendAt.nil?
        end  
      end
      parse_reply(:dispatchMessage, reply)
    end

    private
    
    def self.uri()
        return '/NotificationService'
    end
        
    def self.parse_reply(operationName, reply)
      if reply.kind_of?Fault
        return reply
      else
        case operationName
        when :getTopics
          tpcsArray = Array.new  
          criteriaDefArray = Array.new
          criArray = Array.new 
          
          i = 1
          numTopics = reply.xpath('//ns:getTopicsResponse/ns:topicsArray/ns:topic', 'ns' => SERVICE_NAMESPACE).count
          until i > numTopics
            numCriDef = reply.xpath("//ns:getTopicsResponse/ns:topicsArray/ns:topic[#{i}]/ns:criteriaDefinitionArray/ns:criteriaDefinition", 'ns' => SERVICE_NAMESPACE).count
            j = 1
            until j > numCriDef
              criteriaDefArray << GetTopics::CriteriaDefinition.new(
                content_at(reply.at_xpath("//ns:getTopicsResponse/ns:topicsArray/ns:topic[#{i}]/ns:criteriaDefinitionArray/ns:criteriaDefinition[#{j}]/ns:name", 'ns' => SERVICE_NAMESPACE)),
                content_at(reply.at_xpath("//ns:getTopicsResponse/ns:topicsArray/ns:topic[#{i}]/ns:criteriaDefinitionArray/ns:criteriaDefinition[#{j}]/ns:valueDataType", 'ns' => SERVICE_NAMESPACE)),
                content_at(reply.at_xpath("//ns:getTopicsResponse/ns:topicsArray/ns:topic[#{i}]/ns:criteriaDefinitionArray/ns:criteriaDefinition[#{j}]/ns:condition", 'ns' => SERVICE_NAMESPACE))
              )
              j = j + 1;
            end
            
            criteriaDefinitionArray = GetTopics::CriteriaDefinitionArray.new(criteriaDefArray)
            criteriaDefArray = []
            
            numCriteria = reply.xpath("//ns:getTopicsResponse/ns:topicsArray/ns:topic[#{i}]/ns:subscription/ns:criteriaArray/ns:criteria", 'ns' => SERVICE_NAMESPACE).count
            j = 1
            until j > numCriteria
              value = GetTopics::Value.new(
                content_at(reply.at_xpath("//ns:getTopicsResponse/ns:topicsArray/ns:topic[#{i}]/ns:subscription/ns:criteriaArray/ns:criteria[#{j}]/ns:value/ns:decimalValue", 'ns' => SERVICE_NAMESPACE)),
                content_at(reply.at_xpath("//ns:getTopicsResponse/ns:topicsArray/ns:topic[#{i}]/ns:subscription/ns:criteriaArray/ns:criteria[#{j}]/ns:value/ns:dateValue", 'ns' => SERVICE_NAMESPACE)),
                content_at(reply.at_xpath("//ns:getTopicsResponse/ns:topicsArray/ns:topic[#{i}]/ns:subscription/ns:criteriaArray/ns:criteria[#{j}]/ns:value/ns:stringValue", 'ns' => SERVICE_NAMESPACE))
              )
              criArray << GetTopics::RepCriteria.new(
                content_at(reply.at_xpath("//ns:getTopicsResponse/ns:topicsArray/ns:topic[#{i}]/ns:subscription/ns:criteriaArray/ns:criteria[#{j}]/ns:name", 'ns' => SERVICE_NAMESPACE)),
                value
              )
              j = j + 1;
            end
            
            criteriaArray = GetTopics::CriteriaArray.new(criArray)
            criArray = []
            
            subscription = GetTopics::Subscription.new(
              content_at(reply.at_xpath("//ns:getTopicsResponse/ns:topicsArray/ns:topic[#{i}]/ns:subscription/ns:subscribedAt", 'ns' => SERVICE_NAMESPACE)),
              criteriaArray
            )
            
            tpcsArray << GetTopics::Topic.new(
              content_at(reply.at_xpath("//ns:getTopicsResponse/ns:topicsArray/ns:topic[#{i}]/ns:topicName", 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath("//ns:getTopicsResponse/ns:topicsArray/ns:topic[#{i}]/ns:topicDisplayName", 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath("//ns:getTopicsResponse/ns:topicsArray/ns:topic[#{i}]/ns:topicGroup", 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath("//ns:getTopicsResponse/ns:topicsArray/ns:topic[#{i}]/ns:needsSubscription", 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath("//ns:getTopicsResponse/ns:topicsArray/ns:topic[#{i}]/ns:notifyByEmail", 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath("//ns:getTopicsResponse/ns:topicsArray/ns:topic[#{i}]/ns:notifyBySMS", 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath("//ns:getTopicsResponse/ns:topicsArray/ns:topic[#{i}]/ns:canBeBatched", 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath("//ns:getTopicsResponse/ns:topicsArray/ns:topic[#{i}]/ns:subscriptionProvider", 'ns' => SERVICE_NAMESPACE)),
              (criteriaDefinitionArray.criteriaDefinition.empty? ? nil : criteriaDefinitionArray),
              (subscription.subscribedAt.nil? ? nil : subscription)
            )
            i = i + 1;
          end;
          
          topicsArray = GetTopics::TopicsArray.new(tpcsArray)
          return GetTopics::Result.new(
            content_at(reply.at_xpath('//ns:getTopicsResponse/ns:version', 'ns' => SERVICE_NAMESPACE)),
            (topicsArray.topic.empty? ? nil : topicsArray)
          ) 
        when :setSubscription
          return SetSubscription::Result.new(
            content_at(reply.at_xpath('//ns:setSubscriptionResponse/ns:version', 'ns' => SERVICE_NAMESPACE)),
            content_at(reply.at_xpath('//ns:setSubscriptionResponse/ns:subscribedAt', 'ns' => SERVICE_NAMESPACE))
          )
        when :deleteSubscription
          return DeleteSubscription::Result.new(
            content_at(reply.at_xpath('//ns:deleteSubscriptionResponse/ns:version', 'ns' => SERVICE_NAMESPACE)),
            content_at(reply.at_xpath('//ns:deleteSubscriptionResponse/ns:subscribedAt', 'ns' => SERVICE_NAMESPACE))
          )
        when :sendMessage
          return SendMessage::Result.new(
            content_at(reply.at_xpath('//ns:sendMessageResponse/ns:version', 'ns' => SERVICE_NAMESPACE)),
            content_at(reply.at_xpath('//ns:sendMessageResponse/ns:uniqueResponseNo', 'ns' => SERVICE_NAMESPACE))
          )
        when :dispatchMessage
          return DispatchMessage::Result.new(
            content_at(reply.at_xpath('//ns:dispatchMessageResponse/ns:version', 'ns' => SERVICE_NAMESPACE)),
            content_at(reply.at_xpath('//ns:dispatchMessageResponse/ns:uniqueResponseNo', 'ns' => SERVICE_NAMESPACE))
          )
        end         
      end
    end
    
    def url
      return '/NotificationService'
    end

  end
end