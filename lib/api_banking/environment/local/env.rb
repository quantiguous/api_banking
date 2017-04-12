module ApiBanking
  module Environment
    LOCAL = Struct.new(:host, :port, :protocol, :endpoints) do
      def initialize(*)
        super
        self.port ||= 80
        self.protocol ||= 'http'

        self.endpoints = {
          FundsTransferByCustomerService:  "#{protocol}://#{host}:#{port}/fundsTransferByCustomerServiceHttpService",
          FundsTransferByCustomerService2: "#{protocol}://#{host}:#{port}/fundsTransferByCustomerService2",
          InstantMoneyTransferService:     "#{protocol}://#{host}:#{port}/IMTService",
          DomesticRemittanceByPartnerService:    "#{protocol}://#{host}:#{port}/DomesticRemittanceByPartnerService",
          NotificationService:             "#{protocol}://#{host}:#{port}/NotificationService",
          InstantCreditService:            "#{protocol}://#{host}:#{port}/InstantCreditService",
          PrepaidCardManagementService:    "#{protocol}://#{host}:#{port}/PrepaidCardManagementService",
          PrepaidCardService:              "#{protocol}://#{host}:#{port}/PrepaidCardService",
          SocialBankingService:            "#{protocol}://#{host}:#{port}/SocialBankingService",
          VirtualCardManagementService:    "#{protocol}://#{host}:#{port}/VirtualCardManagementService"
        }
      end
    end
  end  
end
