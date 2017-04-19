require 'json'
module ApiBanking

  class JsonClient

    def self.do_remote_call(env, dataHash, callbacks = nil)
      options = {}
      options[:method] = :post

      add_signature(dataHash)
      options[:body] = JSON.generate(dataHash)

      options[:headers] = {'Content-Type' => "application/json; charset=utf-8", 'User-Agent' => "Quantiguous; API Banking, Ruby Gem #{ApiBanking::VERSION}"}

      set_options_for_environment(env, options)
      set_params_for_environment(env, options)

      request = Typhoeus::Request.new(env.endpoints[self.name.split('::').last.to_sym], options)

      callbacks.before_send.call(request) if (callbacks && callbacks.before_send.respond_to?(:call))
      response = request.run
      callbacks.on_complete.call(request.response) if (callbacks && callbacks.on_complete.respond_to?(:call))
      
      Thread.current[:last_response] = response

      parse_response(response)
    end


    private

    def self.add_signature(dataHash)
      dataHash.first[1][:Signature] = {}
      dataHash.first[1][:Signature][:Signature] = 'Signature'
    end
    
    def self.set_params_for_environment(env, options)
      params = {}
      params[:client_id] = env.client_id
      params[:client_secret] = env.client_secret
      options[:params] = params
    end

    def self.set_options_for_environment(env, options)
      if env.kind_of?ApiBanking::Environment::RBL::UAT or env.kind_of?ApiBanking::Environment::RBL::PROD
        options[:userpwd] = "#{env.user}:#{env.password}"
        options[:cainfo] = env.ssl_ca_file
        options[:sslkey] = env.ssl_client_key
        options[:sslcert] = env.ssl_client_cert
        options[:ssl_verifypeer] = true
      end
      puts "#{options}"
      puts env
    end

    def self.parse_response(response)
      p response.response_body

      if response.success?
# RBL does not set the content-type correctly, it sends text/plain for json!        
#        if response.headers['Content-Type'] =~ /json/
          j = JSON::parse(response.response_body)
          if j.first[1]['Header']['Status'] == 'FAILED'
            return Fault.new(j.first[1]['Header']['Error_Cde'], nil, j.first[1]['Header']['Error_Desc'])
          end
          return j
#        end
      elsif response.timed_out?
        return Fault.new("502", "", "#{response.return_message}")
      elsif response.code == 0
        return Fault.new(response.code, "", response.return_message)
      else
        # http status indicating error
        if response.headers['Content-Type'] =~ /xml/
           reply = Nokogiri::XML(response.response_body)

           # service failures return a fault
           unless reply.at_xpath('//soapenv12:Fault', 'soapenv12' => 'http://www.w3.org/2003/05/soap-envelope').nil? then
             return parse_fault(reply)
           end

           # datapower failures return an xml
           unless reply.at_xpath('//errorResponse').nil?
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
