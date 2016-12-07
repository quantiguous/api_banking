module ApiBanking

  class SoapClient

    def self.last_response
      Thread.current[:last_response]
    end

    def self.do_remote_call(env, callbacks = ApiBanking::Callbacks.new, soapAction = nil, &block)
      data = construct_envelope(&block)
      options = {}
      options[:method] = :post
      options[:body] = data.to_xml

      # add soap11/12 specific headers
      add_soap_headers(options, soapAction)

      # TODO: configuration removed for thread-safety, the assumption that one app at one time will connect to one environment
      # isn't valid anymore (starkit)
      # options[:proxy] = self.configuration.proxy
      # options[:timeout] = self.configuration.timeout

      set_options_for_environment(env, options)

      options[:headers]['User-Agent'] = "Quantiguous; API Banking, Ruby Gem #{ApiBanking::VERSION}"

      request = Typhoeus::Request.new(env.endpoints[self.name.split('::').last.to_sym], options)

      callbacks.before_send.call(request) if callbacks.before_send.respond_to? :call
      response = request.run
      callbacks.on_complete.call(request.response) if callbacks.on_complete.respond_to? :call

      Thread.current[:last_response] = response

      parse_response(response)
    end


    private

    def self.set_options_for_environment(env, options)
      if env.kind_of?ApiBanking::Environment::YBL::PRD
        options[:username] = env.user
        options[:password] = env.password
        options[:headers]["X-IBM-Client-Id"] = env.client_id
        options[:headers]["X-IBM-Client-Secret"] = env.client_secret
        options[:cainfo] = env.ssl_ca_file
        options[:sslkey] = env.ssl_client_key
        options[:keypasswd] = env.ssl_client_key_pass
        options[:sslcert] = env.ssl_client_cert
        options[:ssl_verifypeer] = true
      elsif env.kind_of?ApiBanking::Environment::YBL::UAT
        options[:username] = env.user
        options[:password] = env.password
        options[:headers]["X-IBM-Client-Id"] = env.client_id
        options[:headers]["X-IBM-Client-Secret"] = env.client_secret
      elsif env.kind_of?ApiBanking::Environment::QG::DEMO
        options[:username] = env.user
        options[:password] = env.password
      end
    end



    def self.parse_response(response)
      if response.success?
        if response.headers['Content-Type'] =~ /xml/ then
           return Nokogiri::XML(response.response_body)
        end
      elsif response.timed_out?
        return Fault.new("502", "", "#{response.return_message}")
      elsif response.code == 0
        return Fault.new(response.code, "", response.return_message)
      else
        # http status indicating error, is either a datapower failure or a soap fault
        if response.headers['Content-Type'] =~ /xml/ then
           reply = Nokogiri::XML(response.response_body)

           # datapower failures return an xml
           unless reply.at_xpath('//errorResponse').nil? then
             return parse_dp_reply(reply)
           end

           # has to be a soapfault
           return parse_fault(reply)

        end
        return Fault.new("#{response.code.to_s}", "", response.status_message)
      end
    end

    def self.parse_dp_reply(reply)
      code = content_at(reply.at_xpath('/errorResponse/httpCode'))
      reasonText = content_at(reply.at_xpath('/errorResponse/moreInformation'))
      return Fault.new(code, "", reasonText)
    end

    def self.content_at(node)
      node.content unless node.nil?
    end

  end

  class Soap12Client < SoapClient
    private

    def self.add_soap_headers(options, soapAction)
      options[:headers] = {'Content-Type' => "application/xml; charset=utf-8"}

      # SOAPAction header is not allowed for Soap12
      # options[:headers][:SOAPAction] = data.doc.at_xpath('/soapenv12:Envelope/soapenv12:Body/*', 'soapenv12' => 'http://www.w3.org/2003/05/soap-envelope').name

    end

    def self.construct_envelope(&block)
      Nokogiri::XML::Builder.new do |xml|
        xml.Envelope("xmlns:soap12" => "http://www.w3.org/2003/05/soap-envelope",
                     "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
                     "xmlns:xsd" => "http://www.w3.org/2001/XMLSchema") do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['soap12'].Header
          xml['soap12'].Body(&block)
        end
      end
    end

    def self.parse_fault(reply)
      code   = content_at(reply.at_xpath('//soapenv12:Fault/soapenv12:Code/soapenv12:Subcode/soapenv12:Value', 'soapenv12' => 'http://www.w3.org/2003/05/soap-envelope'))
      subcode   = content_at(reply.at_xpath('//soapenv12:Fault/soapenv12:Code/soapenv12:Subcode/soapenv12:Subcode/soapenv12:Value', 'soapenv12' => 'http://www.w3.org/2003/05/soap-envelope'))
      reasonText   = content_at(reply.at_xpath('//soapenv12:Fault/soapenv12:Reason/soapenv12:Text', 'soapenv12' => 'http://www.w3.org/2003/05/soap-envelope'))

      code ||= 'ns:E500'  # in certain cases, a fault code isn't set by the server
      return Fault.new(code, subcode, reasonText)
    end


  end

  class Soap11Client < SoapClient
    private

    def self.add_soap_headers(options, soapAction)
      options[:headers] = {'Content-Type' => "text/xml;charset=UTF-8"}

      # SOAPAction header is mandatory for Soap11
      options[:headers][:SOAPAction] = soapAction
    end

    def self.construct_envelope(&block)
      Nokogiri::XML::Builder.new do |xml|
        xml.Envelope("xmlns:soap11" => "http://schemas.xmlsoap.org/soap/envelope/",
                     "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
                     "xmlns:xsd" => "http://www.w3.org/2001/XMLSchema") do
          xml.parent.namespace = xml.parent.namespace_definitions.first
          xml['soap11'].Header
          xml['soap11'].Body(&block)
        end
      end
    end

    def self.parse_fault(reply)
      code   = nil # soap11 fault codes are meaningless
      reasonText   = content_at(reply.at_xpath('//soapenv11:Fault/faultstring', 'soapenv11' => 'http://schemas.xmlsoap.org/soap/envelope/'))

      code ||= 'ns:E500'  # in certain cases, a fault code isn't set by the server
      return Fault.new(code, nil, reasonText)
    end


  end
end
