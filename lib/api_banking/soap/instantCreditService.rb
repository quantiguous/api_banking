module ApiBanking
  class InstantCreditService < SoapClient
    
    SERVICE_NAMESPACE = 'http://www.quantiguous.com/services'
    SERVICE_VERSION = 1
    
    attr_accessor :request, :result
    
    #payNow
    module PayNow
      InvoiceDetail = Struct.new(:invoiceNo, :invoiceDate, :dueDate, :invoiceAmount)
      Request = Struct.new(:version, :uniqueRequestNo, :customerID, :appID, :supplierCode, :invoiceDetail, :discountedAmount, :feeAmount)
      Result = Struct.new(:version, :requestReferenceNo, :creditReferenceNo)
    end
    
    #getStatus
    module GetStatus
      Request = Struct.new(:version, :appID, :customerID, :requestReferenceNo)
      Status = Struct.new(:statusCode, :subStatusCode, :subStatusText)
      Result = Struct.new(:version, :requestReferenceNo, :status, :creditReferenceNo)
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
        
    def self.pay_now(request)
      reply = do_remote_call do |xml|
        xml.payNow("xmlns:ns" => SERVICE_NAMESPACE ) do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['ns'].version SERVICE_VERSION
          xml['ns'].uniqueRequestNo request.uniqueRequestNo
          xml['ns'].customerID request.customerID
          xml['ns'].appID request.appID
          xml['ns'].supplierCode request.supplierCode
          xml['ns'].invoiceDetail do  |xml|
            xml.invoiceNo request.invoiceDetail.invoiceNo
            xml.invoiceDate request.invoiceDetail.invoiceDate
            xml.dueDate request.invoiceDetail.dueDate
            xml.invoiceAmount request.invoiceDetail.invoiceAmount
          end
          xml.discountedAmount request.discountedAmount
          xml.feeAmount request.feeAmount
        end
      end
      parse_reply(:payNow, reply)
    end

    
    def self.get_status(request)
      reply = do_remote_call do |xml|
        xml.getStatus("xmlns:ns" => SERVICE_NAMESPACE ) do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['ns'].version SERVICE_VERSION
          xml['ns'].customerID request.customerID
          xml['ns'].appID request.appID
          xml['ns'].requestReferenceNo request.requestReferenceNo
        end
      end
      parse_reply(:getStatus, reply)
    end

    private
    
    def self.uri()
        return '/InstantCreditService'
    end
        
    def self.parse_reply(operationName, reply)
      if reply.kind_of?Fault
        return reply
      else
        case operationName
          when :payNow
            return PayNow::Result.new(
              content_at(reply.at_xpath('//ns:payNowResponse/ns:version', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:payNowResponse/ns:requestReferenceNo', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:payNowResponse/ns:creditReferenceNo', 'ns' => SERVICE_NAMESPACE))
              )
          when :getStatus
            status = GetStatus::Status.new(
              content_at(reply.at_xpath('//ns:getStatusResponse/ns:status/ns:statusCode', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getStatusResponse/ns:status/ns:subStatusCode', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getStatusResponse/ns:status/ns:subStatusText', 'ns' => SERVICE_NAMESPACE))
            )
            return GetStatus::Result.new(
              content_at(reply.at_xpath('//ns:getStatusResponse/ns:version', 'ns' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//ns:getStatusResponse/ns:requestReferenceNo', 'ns' => SERVICE_NAMESPACE)),
              status,
              content_at(reply.at_xpath('//ns:getStatusResponse/ns:creditReferenceNo', 'ns' => SERVICE_NAMESPACE))
            ) 
        end         
      end
    end
    
    def url
      return '/InstantCreditService'
    end

  end
end
