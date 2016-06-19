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
            DomesticRemittanceByPartnerService:     'https://api.quantiguous.com/DomesticRemittanceByPartnerService'
          }
        end
      end
    end
  end  
end
