module ApiBanking
  module Environment
    module QG
      DEMO = Struct.new(:user, :password, :endpoints) do
        def initialize(*)
          super
          self.endpoints = {
            FundsTransferByCustomerService:  'https://api.quantiguous.com/fundsTransferByCustomerServiceHttpService',
            FundsTransferByCustomerService2: 'http://10.211.55.6:7801/fundsTransferByCustomerService2',
            InstantMoneyTransferService:     'https://api.quantiguous.com/IMTService',
            DomesticRemittanceByPartnerService:    'https://api.quantiguous.com/DomesticRemittanceByPartnerService' 
            NotificationService:             'https://api.quantiguous.com/NotificationService'
          }
        end
      end
    end
  end  
end
