module ApiBanking
  module Environment
    module YBL
      UAT = Struct.new(:user, :password, :client_id, :client_secret, :url) do
        def initialize(*)
          super
          self.url ||= 'https://uatsky.yesbank.in/app/uat/'
        end
      end
      
      PRD = Struct.new(:user, :password, :client_id, :client_secret, :ssl_client_cert, :ssl_client_key, :ssl_ca_file, :url) do
        def initialize(*)
          super
          self.ssl_ca_file ||= File.expand_path('./prd.pem', File.dirname(__FILE__))
          self.url ||= 'https://sky.yesbank.in:444/app/live/ssl'
        end
      end
    end
  end  
end
