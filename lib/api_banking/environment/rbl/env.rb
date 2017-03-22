module ApiBanking
  module Environment
    module RBL
      UAT = Struct.new(:user, :password, :client_id, :client_secret, :ssl_client_cert, :ssl_client_key, :ssl_ca_file, :endpoints) do
        def initialize(*)
          super
          self.ssl_ca_file ||= File.expand_path('./uat.pem', File.dirname(__FILE__))
          self.endpoints = {
            SinglePayment: 'https://apideveloper.rblbank.com/test/sb/rbl/v1/payments/corp/payment',
            AccountStatement: 'https://apideveloper.rblbank.com/test/sb/rbl/v1/cas/statement'
          }
        end
      end
    end
  end  
end
