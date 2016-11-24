module ApiBanking
  module Environment
    module YBL
      UAT = Struct.new(:user, :password, :client_id, :client_secret, :endpoints) do
        def initialize(*)
          super
          self.endpoints = {
            FundsTransferByCustomerService:  'https://uatsky.yesbank.in/app/uat/fundsTransferByCustomerServiceHttpService',
            FundsTransferByCustomerService2: 'https://uatsky.yesbank.in/app/uat/ssl/fundsTransferByCustomerSevice2',
            InstantMoneyTransferService:     'https://uatsky.yesbank.in/app/uat/IMTService',
            InstantCreditService:            'https://uatsky.yesbank.in/app/uat/ssl/InstantCreditService',
            PrepaidCardManagementService:    'https://uatsky.yesbank.in/app/uat/PrepaidCardManagementService',
            PrepaidCardService:              'https://uatsky.yesbank.in/app/uat/PrepaidCardService',
            SocialBankingService:            'https://uatsky.yesbank.in/app/uat/SocialBankingServiceHttpService',
            VirtualCardManagementService:    'https://uatsky.yesbank.in/app/uat/VirtualCardManagementService',
            InwardRemittanceByPartnerService: 'https://uatsky.yesbank.in/app/uat/InwardRemittanceByPartnerService',
            AadhaarVerificationService:      'https://uatsky.yesbank.in/app/uat/ssl/eKYC'
          }
        end
      end
      
      PRD = Struct.new(:user, :password, :client_id, :client_secret, :ssl_client_cert, :ssl_client_key, :ssl_client_key_pass, :ssl_ca_file, :endpoints) do
        def initialize(*)
          super
          self.ssl_ca_file ||= File.expand_path('./prd.pem', File.dirname(__FILE__))
          self.endpoints = {
            SocialBankingService:            'https://sky.yesbank.in/app/live/SocialBankingServiceHttpService',
            FundsTransferByCustomerService:  'https://sky.yesbank.in:444/app/live/ssl/fundsTransferByCustomerService',
            FundsTransferByCustomerService2:  'https://sky.yesbank.in:444/app/live/fundsTransferByCustomerService2'
          }          
        end
      end
    end
  end  
end
