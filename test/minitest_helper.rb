$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'api_banking'

require 'minitest/autorun'
require 'securerandom'
require 'webmock/minitest'
require 'vcr'

VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = true
  c.cassette_library_dir = "test/fixtures"
  c.hook_into :webmock
  c.default_cassette_options = {:record => :new_episodes}
end

Typhoeus::Config.verbose = false

ybl_uat = ApiBanking::Environment::YBL::UAT.new(ENV['API_UAT_USER'], ENV['API_UAT_PASSWORD'], ENV['API_UAT_CLIENT_ID'], ENV['API_UAT_CLIENT_SECRET']  )
rbl_uat = ApiBanking::Environment::RBL::UAT.new(ENV['API_RBL_UAT_USER'], ENV['API_RBL_UAT_PASSWORD'], ENV['API_RBL_UAT_CLIENT_ID'], ENV['API_RBL_UAT_CLIENT_SECRET'], ENV['API_RBL_UAT_CLIENT_CERT'], ENV['API_RBL_UAT_CLIENT_KEY']  )
rbl_prd = ApiBanking::Environment::RBL::PROD.new(ENV['API_RBL_UAT_USER'], ENV['API_RBL_UAT_PASSWORD'], ENV['API_RBL_UAT_CLIENT_ID'], ENV['API_RBL_UAT_CLIENT_SECRET'], ENV['API_RBL_UAT_CLIENT_CERT'], ENV['API_RBL_UAT_CLIENT_KEY']  )
ybl_prd = ApiBanking::Environment::YBL::PRD.new(ENV['API_USER'], ENV['API_PASSWORD'], ENV['API_CLIENT_ID'], ENV['API_CLIENT_SECRET'], ENV['API_CLIENT_CERT'], ENV['API_CLIENT_KEY'])
qg_aws =  ApiBanking::Environment::QG::DEMO.new(ENV['API_QG_USER'], ENV['API_QG_PASSWORD'])

FundsTransferByCustomerService2Environment = qg_aws
InstantMoneyTransferServiceEnvironment = ybl_uat
FundsTransferByCustomerServiceEnvironment = ybl_uat
SinglePaymentEnvironment = rbl_uat
AccountStatementEnvironment = rbl_uat
GetAccountBalanceEnvironment = rbl_prd
GetPaymentStatusEnvironment = rbl_uat
DomesticRemittanceByPartnerServiceEnvironment = qg_aws
NotificationServiceEnvironment = qg_aws
InstantCreditServiceEnvironment = qg_aws
PrepaidCardManagementServiceEnvironment = qg_aws
PrepaidCardServiceEnvironment = ybl_uat
SocialBankingServiceEnvironment = ybl_prd
InwardRemittanceByPartnerServiceEnvironment = ybl_uat
AadhaarVerificationServiceEnvironment = ybl_uat
VirtualCardManagementServiceEnvironment = ybl_uat
PanInquiryEnvironment = rbl_uat
