module ApiBanking
  module Environment
    module YBL
      UAT = Struct.new(:user, :password, :client_id, :client_secret, :endpoints) do
        def initialize(*)
          super
          self.endpoints = {
            FundsTransferByCustomerService:  'https://uatsky.yesbank.in/app/uat/fundsTransferByCustomerServiceHttpService',
            FundsTransferByCustomerService2: 'http://10.211.55.6:7801/fundsTransferByCustomerService2',
            InstantMoneyTransferService:     'https://uatsky.yesbank.in:7081/IMTService',
            NotificationService:             'http://10.211.55.6:7802/NotificationService'
          }
        end
      end
      
      PRD = Struct.new(:user, :password, :client_id, :client_secret, :ssl_client_cert, :ssl_client_key, :ssl_ca_file, :endpoints) do
        def initialize(*)
          super
          self.ssl_ca_file ||= File.expand_path('./prd.pem', File.dirname(__FILE__))
          self.endpoints = {
            FundsTransferByCustomerService:  'https://sky.yesbank.in:444/app/live/ssl/fundsTransferByCustomerService'
          }          
        end
      end
    end
  end  
end
