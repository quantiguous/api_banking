module ApiBanking
  class NotificationService < SoapClient
    
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
            j = 0
            until j > numCriDef
              criteriaDefArray << GetTopics::CriteriaDefinition.new(
                content_at(reply.at_xpath("//ns:getTopicsResponse/ns:topicsArray/ns:topic[#{i}]/ns:criteriaDefinitionArray/ns:criteriaDefinition[#{j}]/ns:name", 'ns' => SERVICE_NAMESPACE)),
                content_at(reply.at_xpath("//ns:getTopicsResponse/ns:topicsArray/ns:topic[#{i}]/ns:criteriaDefinitionArray/ns:criteriaDefinition[#{j}]/ns:valueDataType", 'ns' => SERVICE_NAMESPACE)),
                content_at(reply.at_xpath("//ns:getTopicsResponse/ns:topicsArray/ns:topic[#{i}]/ns:criteriaDefinitionArray/ns:criteriaDefinition[#{j}]/ns:condition", 'ns' => SERVICE_NAMESPACE))
              )
              j = j + 1;
            end
            
            criteriaDefinitionArray = GetTopics::CriteriaDefinitionArray.new(criteriaDefArray)
            
            numCriteria = reply.xpath("//ns:getTopicsResponse/ns:topicsArray/ns:topic[#{i}]/ns:subscription/ns:criteriaArray/ns:criteria", 'ns' => SERVICE_NAMESPACE).count
            j = 0
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
            
            subscription = GetTopics::Subscription.new(
              content_at(reply.at_xpath("//ns:getTopicsResponse/ns:topicsArray/ns:topic[#{i}]/ns:subscription/ns:sunscribedAt", 'ns' => SERVICE_NAMESPACE)),
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
              criteriaDefinitionArray,
              subscription
            )
            i = i + 1;
          end;
          
          topicsArray = GetTopics::TopicsArray.new(tpcsArray)
          return GetTopics::Result.new(
            content_at(reply.at_xpath('//ns:getTopicsResponse/ns:version', 'ns' => SERVICE_NAMESPACE)),
            topicsArray
          ) 
        end         
      end
    end
    
    def url
      return '/NotificationService'
    end

  end
end