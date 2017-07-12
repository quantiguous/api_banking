module ApiBanking
  class PanInquiry < JsonClient

    SERVICE_VERSION = 1

    attr_accessor :request, :result

    ReqHeader = Struct.new(:tranID, :corpID)
    ReqBody = Struct.new(:panNumber)
    Request = Struct.new(:header, :body)

    Result = Struct.new(:panStatus, :lastName, :firstName, :middleName, :panTitle, :lastUpdateDate)

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

    def self.pan_inquiry(env, request, callbacks = nil)
      dataHash = {}
      dataHash[:panInquiry] = {}
      dataHash[:panInquiry][:Header] = {}
      dataHash[:panInquiry][:Body] = {}

      dataHash[:panInquiry][:Header][:TranID] = request.header.tranID
      dataHash[:panInquiry][:Header][:Corp_ID] = request.header.corpID

      dataHash[:panInquiry][:Body][:panNumbers] = []
      dataHash[:panInquiry][:Body][:panNumbers][0] = {}
      
      dataHash[:panInquiry][:Body][:panNumbers][0][:pan1] = request.body.panNumber

      reply = do_remote_call(env, dataHash, callbacks)

      parse_reply(reply)
    end

    private

    def self.parse_reply(reply)
      if reply.kind_of?Fault
        reply
      else
        PanInquiry::Result.new(
          reply['panInquiryResponse']['Body']['panDetails'][0]['panstatus'],
          reply['panInquiryResponse']['Body']['panDetails'][0]['lastname'],
          reply['panInquiryResponse']['Body']['panDetails'][0]['firstname'],
          reply['panInquiryResponse']['Body']['panDetails'][0]['middlename'],
          reply['panInquiryResponse']['Body']['panDetails'][0]['pan-title'],
          reply['panInquiryResponse']['Body']['panDetails'][0]['last-update-date']
        )
      end
    end
  end
end