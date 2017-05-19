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
            NotificationService:             'https://api.quantiguous.com/Apprise/NotificationService',
            InstantCreditService:            'https://api.quantiguous.com/InstantCreditService',
            PrepaidCardManagementService:    'https://api.quantiguous.com/PrepaidCardManagementService',
            PrepaidCardService:              'https://api.quantiguous.com/PrepaidCardService',
            SocialBankingService:            'https://api.quantiguous.com/SocialBankingService',
            VirtualCardManagementService:    'https://api.quantiguous.com/VirtualCardManagementService'
          }
        end
      end
    end
  end  
end
