require 'json'
module ApiBanking

  class JsonClient

    def self.do_remote_call(dataHash, callbacks = nil)
      options = {}
      options[:method] = :post

      add_signature(dataHash)
      options[:body] = JSON.generate(dataHash)

      options[:headers] = {'Content-Type' => "application/json; charset=utf-8"}

      options[:proxy] = self.configuration.proxy
      options[:timeout] = self.configuration.timeout

      set_options_for_environment(options)
      set_params_for_environment(options)

      request = Typhoeus::Request.new(self.configuration.environment.url + uri, options)

      callbacks.before_send.call(request) if (callbacks && callbacks.before_send.respond_to?(:call))
      response = request.run
      callbacks.on_complete.call(request.response) if (callbacks && callbacks.on_complete.respond_to?(:call))

      parse_response(response)
    end


    private

    def self.add_signature(dataHash)
      dataHash[:Single_Payment_Corp_Req][:Signature] = {}
      dataHash[:Single_Payment_Corp_Req][:Signature][:Signature] = 'Signature'
    end

    def self.set_params_for_environment(options)
      params = {}
      params[:client_id] = self.configuration.environment.client_id
      params[:client_secret] = self.configuration.environment.client_secret
      options[:params] = params
    end

    def self.set_options_for_environment(options)
      if self.configuration.environment.kind_of?ApiBanking::Environment::RBL::UAT
        options[:userpwd] = "#{self.configuration.environment.user}:#{self.configuration.environment.password}"
        options[:cainfo] = self.configuration.environment.ssl_ca_file
        options[:sslkey] = self.configuration.environment.ssl_client_key
        options[:sslcert] = self.configuration.environment.ssl_client_cert
        options[:ssl_verifypeer] = true
      end
      puts "#{options}"
    end

    def self.parse_response(response)
      if response.success?
        if response.headers['Content-Type'] =~ /json/ then
          j = JSON::parse(response.response_body)
          if j[:Status] = 'FAILED' then
            return Fault.new(j[:Status], j.first[1]['Header']['Error_Cde'], j.first[1]['Header']['Error_Desc'])
          end
          return j
        end
      elsif response.timed_out?
        return Fault.new("502", "", "#{response.return_message}")
      elsif response.code == 0
        return Fault.new(response.code, "", response.return_message)
      else
        # http status indicating error
        if response.headers['Content-Type'] =~ /xml/ then
           reply = Nokogiri::XML(response.response_body)

           # service failures return a fault
           unless reply.at_xpath('//soapenv12:Fault', 'soapenv12' => 'http://www.w3.org/2003/05/soap-envelope').nil? then
             return parse_fault(reply)
           end

           # datapower failures return an xml
           unless reply.at_xpath('//errorResponse').nil? then
             return parse_dp_reply(reply)
           end

        end
        return Fault.new("#{response.code.to_s}", "", response.status_message)
      end
    end

    def self.parse_dp_reply(reply)
      code = content_at(reply.at_xpath('/errorResponse/httpCode'))
      reasonText = content_at(reply.at_xpath('/errorResponse/moreInformation'))
      return Fault.new(code, "", reasonText)
    end

    def self.parse_fault(reply)
      code   = content_at(reply.at_xpath('//soapenv12:Fault/soapenv12:Code/soapenv12:Subcode/soapenv12:Value', 'soapenv12' => 'http://www.w3.org/2003/05/soap-envelope'))
      subcode   = content_at(reply.at_xpath('//soapenv12:Fault/soapenv12:Code/soapenv12:Subcode/soapenv12:Subcode/soapenv12:Value', 'soapenv12' => 'http://www.w3.org/2003/05/soap-envelope'))
      reasonText   = content_at(reply.at_xpath('//soapenv12:Fault/soapenv12:Reason/soapenv12:Text', 'soapenv12' => 'http://www.w3.org/2003/05/soap-envelope'))
      return Fault.new(code, subcode, reasonText)
    end

  end
end
