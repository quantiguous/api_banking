require "nokogiri"
require "typhoeus"
require "api_banking/version"
require_relative "api_banking/config"
require_relative "api_banking/environment/rbl/env"
require_relative "api_banking/environment/ybl/env"
require_relative "api_banking/environment/qg/env"

require_relative "api_banking/soap/fault"
require_relative "api_banking/soap/callbacks"
require_relative "api_banking/soap/soap_client"
require_relative "api_banking/soap/fundsTransferByCustomerService"
require_relative "api_banking/soap/fundsTransferByCustomerService2"
require_relative "api_banking/soap/instantMoneyTransferService"
require_relative "api_banking/soap/domesticRemittanceByPartnerService"
require_relative "api_banking/soap/notificationService"
require_relative "api_banking/soap/instantCreditService"
require_relative "api_banking/soap/prepaidCardManagementService"
require_relative "api_banking/soap/prepaidCardService"
require_relative "api_banking/soap/socialBankingService"
require_relative "api_banking/soap/virtualCardManagementService"
require_relative "api_banking/soap/inwardRemittanceByPartnerService"
require_relative "api_banking/soap/aadhaarVerificationService"

require_relative "api_banking/json/json_client"
require_relative "api_banking/json/singlePayment"
require_relative "api_banking/json/accountStatement"

module ApiBanking

end
