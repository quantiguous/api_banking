module ApiBanking
  
  class SoapClient    
    @@last_response = nil

    def self.last_response
      @@last_response
    end
         
    def self.do_remote_call(&block)
      data = construct_envelope(&block)
      options = {}
      options[:method] = :post
      options[:body] = data.to_xml

      options[:headers] = {'Content-Type' => "application/xml; charset=utf-8"}

      # SOAPAction header is not allowed for Soap12
      # options[:headers][:SOAPAction] = data.doc.at_xpath('/soapenv12:Envelope/soapenv12:Body/*', 'soapenv12' => 'http://www.w3.org/2003/05/soap-envelope').name
      
      options[:proxy] = self.configuration.proxy
      options[:timeout] = self.configuration.timeout
      
      set_options_for_environment(options)
      
      options[:headers]['User-Agent'] = "Quantiguous; API Banking, Ruby Gem #{ApiBanking::VERSION}"
      
      request = Typhoeus::Request.new(self.configuration.environment.endpoints[self.name.split('::').last.to_sym], options)
      response = request.run
      
      @@last_response = response 

      parse_response(response)
    end
    

    private 
    def self.set_options_for_environment(options)
      if self.configuration.environment.kind_of?ApiBanking::Environment::YBL::PRD
        options[:userpwd] = "#{self.configuration.environment.user}:#{self.configuration.environment.password}"
        options[:headers]["X-IBM-Client-Id"] = self.configuration.environment.client_id
        options[:headers]["X-IBM-Client-Secret"] = self.configuration.environment.client_secret
        options[:cainfo] = self.configuration.environment.ssl_ca_file
        options[:sslkey] = self.configuration.environment.ssl_client_key
        options[:sslcert] = self.configuration.environment.ssl_client_cert
        options[:ssl_verifypeer] = true
      elsif self.configuration.environment.kind_of?ApiBanking::Environment::YBL::UAT
        options[:userpwd] = "#{self.configuration.environment.user}:#{self.configuration.environment.password}"
        options[:headers]["X-IBM-Client-Id"] = self.configuration.environment.client_id
        options[:headers]["X-IBM-Client-Secret"] = self.configuration.environment.client_secret
      elsif self.configuration.environment.kind_of?ApiBanking::Environment::QG::DEMO
        options[:userpwd] = "#{self.configuration.environment.user}:#{self.configuration.environment.password}"        
      end
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
#      detail = parse_detail(reply.at_xpath('//soapenv12:Fault/soapenv12:Detail', 'soapenv12' => 'http://www.w3.org/2003/05/soap-envelope'))
      
      code ||= 'ns:E500'  # in certain cases, a fault code isn't set by the server
      return Fault.new(code, subcode, reasonText)
    end
    
    def self.parse_detail(node)
      return content_at(node.at_xpath('Text')) # 
    end
    
    def self.content_at(node)
      node.content unless node.nil?
    end
    
    def self.part_name(message)
      message.at_xpath('/soapenv12:Envelope/soapenv12:Body/*', 'soapenv12' => 'http://www.w3.org/2003/05/soap-envelope').name
    end
  end
end
