module ApiBanking
  class SocialBankingService < Soap12Client
    
    SERVICE_NAMESPACE = 'http://www.quantiguous.com/services'
    SERVICE_VERSION = 1
    
    attr_accessor :request, :result
    
    #getTransactions
    module GetTransactions
      Request = Struct.new(:version, :appID, :customerIdentity, :deviceID, :accountIdentity, :numTransactions)
      CustomerIdentity = Struct.new(:customerID, :customerAlternateID)
      CustomerAlternateID = Struct.new(:mobileNo, :emailID, :twitterID, :genericID)
      GenericID = Struct.new(:idType, :idValue)
      AccountIdentity = Struct.new(:accountNo, :registeredAccount)
      
      Transaction = Struct.new(:transactionID, :recordDate, :transactionType, :currencyCode, :amount, :narrative)
      Result = Struct.new(:version, :customerID, :accountNo, :numTransactions, :transactionsArray)
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
    
    def self.getTransactions(env, request)
      reply = do_remote_call(env) do |xml|
        xml.getTransactions("xmlns:ns" => SERVICE_NAMESPACE ) do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['ns'].version SERVICE_VERSION
          xml['ns'].appID request.appID
          xml['ns'].customerIdentity do  |xml|
            xml.customerID request.customerIdentity.customerID unless request.customerIdentity.customerID.nil?
            unless request.customerIdentity.customerAlternateID.nil?
              xml.customerAlternateID do  |xml|
                xml.mobileNo request.customerIdentity.customerAlternateID.mobileNo unless request.customerIdentity.customerAlternateID.mobileNo.nil?
                xml.emailID request.customerIdentity.customerAlternateID.emailID unless request.customerIdentity.customerAlternateID.emailID.nil?
                xml.twitterID request.customerIdentity.customerAlternateID.twitterID unless request.customerIdentity.customerAlternateID.twitterID.nil?
                unless request.customerIdentity.customerAlternateID.genericID.nil?
                  xml.genericID do |xml|
                    xml.idType request.customerIdentity.customerAlternateID.genericID.idType
                    xml.idValue request.customerIdentity.customerAlternateID.genericID.idValue
                  end
                end
              end
            end
          end
          xml['ns'].deviceID request.deviceID
          xml['ns'].accountIdentity do |xml|
            xml.accountNo request.accountIdentity.accountNo unless request.accountIdentity.accountNo.nil?
            xml.registeredAccount request.accountIdentity.registeredAccount unless request.accountIdentity.registeredAccount.nil?
          end
          xml['ns'].numTransactions request.numTransactions
        end
      end
      parse_reply(:getTransactions, reply)
    end
    
    private

    def self.uri()
      return '/SocialBankingService'
    end

    def self.parse_reply(operationName, reply)
      if reply.kind_of?Fault
        return reply
      else
        case operationName
          when :getTransactions
            txnArray = Array.new 
            i = 1
            numTxns = content_at(reply.at_xpath("//ns:getTransactionsResponse/ns:numTransactions", 'ns' => SERVICE_NAMESPACE)).to_i
            until i > numTxns
              txnArray << GetTransactions::Transaction.new(
                content_at(reply.at_xpath("//ns:getTransactionsResponse/ns:transactionsArray/ns:transaction[#{i}]/ns:transactionID", 'ns' => SERVICE_NAMESPACE)),
                Date.strptime(content_at(reply.at_xpath("//ns:getTransactionsResponse/ns:transactionsArray/ns:transaction[#{i}]/ns:recordDate", 'ns' => SERVICE_NAMESPACE)),"%Y-%m-%d"),
                content_at(reply.at_xpath("//ns:getTransactionsResponse/ns:transactionsArray/ns:transaction[#{i}]/ns:transactionType", 'ns' => SERVICE_NAMESPACE)),
                content_at(reply.at_xpath("//ns:getTransactionsResponse/ns:transactionsArray/ns:transaction[#{i}]/ns:currencyCode", 'ns' => SERVICE_NAMESPACE)),
                BigDecimal.new(content_at(reply.at_xpath("//ns:getTransactionsResponse/ns:transactionsArray/ns:transaction[#{i}]/ns:amount", 'ns' => SERVICE_NAMESPACE))),
                content_at(reply.at_xpath("//ns:getTransactionsResponse/ns:transactionsArray/ns:transaction[#{i}]/ns:narrative", 'ns' => SERVICE_NAMESPACE))
              )
              i = i + 1;
            end

            return GetTransactions::Result.new(
              content_at(reply.at_xpath('//ns:getTransactionsResponse/ns:version', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getTransactionsResponse/ns:customerID', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getTransactionsResponse/ns:accountNo', 'ns' => SERVICE_NAMESPACE)),
              txnArray.size,
              txnArray
            )
        end         
      end
    end

    def url
      return '/PrepaidCardService'
    end

  end
end