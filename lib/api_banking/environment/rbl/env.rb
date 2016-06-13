module ApiBanking
  module Environment
    module RBL
      UAT = Struct.new(:user, :password, :client_id, :client_secret, :ssl_client_cert, :ssl_client_key, :ssl_ca_file, :url) do
        def initialize(*)
          super
          self.ssl_ca_file ||= File.expand_path('./uat.pem', File.dirname(__FILE__))
          self.url ||= 'https://apideveloper.rblbank.com'
        end
      end
    end
  end  
end
