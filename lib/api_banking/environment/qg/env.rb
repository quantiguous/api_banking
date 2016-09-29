module ApiBanking
  module Environment
    module QG
      DEMO = Struct.new(:user, :password, :endpoints) do
        def initialize(*)
          super
          self.endpoints = {
            FundsTransferByCustomerService:  'https://api.quantiguous.com/fundsTransferByCustomerServiceHttpService',
            FundsTransferByCustomerService2: 'https://api.quantiguous.com/fundsTransferByCustomerService2',
            InstantMoneyTransferService:     'https://api.quantiguous.com/IMTService',
            DomesticRemittanceByPartnerService:    'https://api.quantiguous.com/DomesticRemittanceByPartnerService', 
            NotificationService:             'https://api.quantiguous.com/NotificationService',
            InstantCreditService:            'https://api.quantiguous.com/InstantCreditService',
            PrepaidCardManagementService:    'http://10.211.55.6:7800/PrepaidCardManagementService',
            PrepaidCardService:              'http://10.211.55.6:7800/PrepaidCardService',
            SocialBankingService:            'https://api.quantiguous.com/SocialBankingService',
            VirtualCardManagementService:    'http://10.211.55.6:7800/VirtualCardManagementService'
          }
        end
      end
    end
  end  
end
