module ApiBanking
  module Environment
    module RBL
      UAT = Struct.new(:user, :password, :client_id, :client_secret, :ssl_client_cert, :ssl_client_key, :ssl_ca_file, :endpoints) do
        def initialize(*)
          super
          self.ssl_ca_file ||= File.expand_path('./uat.pem', File.dirname(__FILE__))
          self.endpoints = {
            SinglePayment: 'https://apideveloper.rblbank.com/test/sb/rbl/v1/payments/corp/payment',
            AccountStatement: 'https://apideveloper.rblbank.com/test/sb/rbl/v1/cas/statement',
            GetAccountBalance: 'https://apideveloper.rblbank.com/test/sb/rbl/v1/accounts/balance/query',
            GetPaymentStatus: 'https://apideveloper.rblbank.com/test/sb/rbl/v1/payments/corp/payment/query'
          }
        end
      end

      PROD = Struct.new(:user, :password, :client_id, :client_secret, :ssl_client_cert, :ssl_client_key, :ssl_ca_file, :endpoints) do
        def initialize(*)
          super
          self.ssl_ca_file ||= File.expand_path('./uat.pem', File.dirname(__FILE__))
          self.endpoints = {
            SinglePayment: 'https://gateway.rblbank.com/prod/sb/rbl/v1/payments/corp/payment',
            AccountStatement: 'https://gateway.rblbank.com/prod/sb/rbl/v1/cas/statement',
            GetAccountBalance: 'https://gateway.rblbank.com/prod/sb/rbl/v1/accounts/balance/query',
            GetPaymentStatus: 'https://gateway.rblbank.com/prod/sb/rbl/v1/payments/corp/payment/query'
          }
        end
      end
    end
  end  
end
