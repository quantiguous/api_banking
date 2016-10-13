module ApiBanking
  class AadhaarVerificationService < SoapClient
    
    SERVICE_NAMESPACE = 'http://xmlns.yesbank.com/WS/EKYCDataElement'
    
    attr_accessor :request, :result
    
    #verification
    module Verification
      Request = Struct.new(:getDemoAuthDataReq)
      GetDemoAuthDataReq = Struct.new(:reqHdr, :reqBody)
      ReqHdr = Struct.new(:consumerContext, :serviceContext)
      ConsumerContext = Struct.new(:requesterID)
      ServiceContext = Struct.new(:serviceName, :reqRefNum, :reqRefTimeStamp, :serviceVersionNo)
      ReqBody = Struct.new(:demographicDataModel)
      DemographicDataModel = Struct.new(:aadhaarName, :aadhaarNo, :agentID, :dob, :gender, :loginKey, :merchantId, :merchantTransactionId, :pincode, :terminalID)
      
      Result = Struct.new(:getDemoAuthDataRes)
      getDemoAuthDataRes = Struct.new(:resHdr)
      ResHdr = Struct.new(:consumerContext, :serviceContext, :serviceResponse, :errorDetails) 
      ServiceResponse = Struct.new(:esbResTimeStamp, :esbResStatus)
      ErrorDetails = Struct.new(:errorInfo)
      ErrorInfo = Struct.new(:errSrc, :hostErrCode, :hostErrDesc)
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
    
    def self.getDemoAuthData(request)
      reply = do_remote_call do |xml|
        xml.aadhaarVerification("xmlns:eky" => SERVICE_NAMESPACE ) do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['eky'].GetDemoAuthDataReq do |demo|
            demo['eky'].ReqHdr do |header|
              header.ConsumerContext do |consumer|
                consumer.RequesterID request.getDemoAuthDataReq.reqHdr.consumerContext.requesterID
              end
              header.ServiceContext do |service|
                service.ServiceName request.getDemoAuthDataReq.reqHdr.serviceContext.serviceName
                service.ReqRefNum request.getDemoAuthDataReq.reqHdr.serviceContext.reqRefNum
                service.ReqRefTimeStamp request.getDemoAuthDataReq.reqHdr.serviceContext.reqRefTimeStamp
                service.ServiceVersionNo request.getDemoAuthDataReq.reqHdr.serviceContext.serviceVersionNo unless request.getDemoAuthDataReq.reqHdr.serviceContext.serviceVersionNo.nil?
              end
            end
            demo['eky'].ReqBody do |body|
              body['eky'].DemographicDataModel do |data|
                data['eky'].AadhaarName request.getDemoAuthDataReq.reqBody.demographicDataModel.aadhaarName
                data['eky'].AadhaarNo request.getDemoAuthDataReq.reqBody.demographicDataModel.aadhaarNo
                data['eky'].AgentID request.getDemoAuthDataReq.reqBody.demographicDataModel.agentID
                data['eky'].DOB  request.getDemoAuthDataReq.reqBody.demographicDataModel.dob
                data['eky'].Gender request.getDemoAuthDataReq.reqBody.demographicDataModel.gender
                data['eky'].LoginKey request.getDemoAuthDataReq.reqBody.demographicDataModel.loginKey unless request.getDemoAuthDataReq.reqBody.demographicDataModel.loginKey.nil?
                data['eky'].MerchantId request.getDemoAuthDataReq.reqBody.demographicDataModel.merchantId unless request.getDemoAuthDataReq.reqBody.demographicDataModel.merchantId.nil?
                data['eky'].MerchantTransactionId request.getDemoAuthDataReq.reqBody.demographicDataModel.merchantTransactionId unless request.getDemoAuthDataReq.reqBody.demographicDataModel.merchantTransactionId.nil?
                data['eky'].pincode request.getDemoAuthDataReq.reqBody.demographicDataModel.pincode unless request.getDemoAuthDataReq.reqBody.demographicDataModel.pincode.nil?
                data['eky'].terminalID request.getDemoAuthDataReq.reqBody.demographicDataModel.terminalID unless request.getDemoAuthDataReq.reqBody.demographicDataModel.terminalID.nil?
              end
            end
          end
        end
      end
      parse_reply(:getDemoAuthData, reply)
    end
    
    private

    def self.uri()
      return '/eKYC'
    end

    Result = Struct.new(:getDemoAuthDataRes)
      getDemoAuthDataRes = Struct.new(:resHdr)
      ResHdr = Struct.new(:consumerContext, :serviceContext, :serviceResponse, :errorDetails) 
      ServiceResponse = Struct.new(:esbResTimeStamp, :esbResStatus)
      ConsumerContext = Struct.new(:requesterID)
      ServiceContext = Struct.new(:serviceName, :reqRefNum, :reqRefTimeStamp, :serviceVersionNo)
      ErrorDetails = Struct.new(:errorInfo)
      ErrorInfo = Struct.new(:errSrc, :hostErrCode, :hostErrDesc)

    def self.parse_reply(operationName, reply)
      if reply.kind_of?Fault
        return reply
      else
        case operationName
          when :getDemoAuthData
            service_response = Verification::ServiceResponse.new(
              content_at(reply.at_xpath('//NS1:getDemoAuthDataRes/NS1:ReqHdr/ServiceResponse/EsbResTimeStamp', 'NS1' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//NS1:getDemoAuthDataRes/NS1:ReqHdr/ServiceResponse/EsbResStatus', 'NS1' => SERVICE_NAMESPACE))
              )
            consumer_context = Verification::ConsumerContext.new(
              content_at(reply.at_xpath('//NS1:getDemoAuthDataRes/NS1:ReqHdr/ConsumerContext/RequesterID', 'NS1' => SERVICE_NAMESPACE))
              )
            service_context = Verification::ServiceContext.new(
              content_at(reply.at_xpath('//NS1:getDemoAuthDataRes/NS1:ReqHdr/ServiceContext/ServiceName', 'NS1' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//NS1:getDemoAuthDataRes/NS1:ReqHdr/ServiceContext/ReqRefNum', 'NS1' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//NS1:getDemoAuthDataRes/NS1:ReqHdr/ServiceContext/ReqRefTimeStamp', 'NS1' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//NS1:getDemoAuthDataRes/NS1:ReqHdr/ServiceContext/ServiceVersionNo', 'NS1' => SERVICE_NAMESPACE))
              )
            error_info = Verification::ErrorInfo.new(
              content_at(reply.at_xpath('//NS1:getDemoAuthDataRes/NS1:ReqHdr/ErrorDetails/ErrorInfo/ErrSrc', 'NS1' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//NS1:getDemoAuthDataRes/NS1:ReqHdr/ErrorDetails/ErrorInfo/HostErrCode', 'NS1' => SERVICE_NAMESPACE)),
              content_at(reply.at_xpath('//NS1:getDemoAuthDataRes/NS1:ReqHdr/ErrorDetails/ErrorInfo/HostErrDesc', 'NS1' => SERVICE_NAMESPACE))
              )
            error_details = Verification::ConsumerContext.new(
              error_info
              )
            header = Verification::ResHdr.new(
              consumer_context,
              service_context,
              service_response,
              error_details                                
              )
            res = Verification::GetDemoAuthDataRes.new(
              header                              
              )
            return Verification::Result.new(
              res
            ) 
        end         
      end
    end

    def url
      return '/eKYC'
    end

  end
end