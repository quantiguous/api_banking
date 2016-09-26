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
ybl_prd = ApiBanking::Environment::YBL::PRD.new(ENV['API_USER'], ENV['API_PASSWORD'], ENV['API_CLIENT_ID'], ENV['API_CLIENT_SECRET'], ENV['API_CLIENT_CERT'], ENV['API_CLIENT_KEY'])
qg_aws =  ApiBanking::Environment::QG::DEMO.new(ENV['API_QG_USER'], ENV['API_QG_PASSWORD'])

ApiBanking::FundsTransferByCustomerService2.configure do |config|
  config.proxy = "10.211.55.2:8080"
  config.environment = qg_aws
end

ApiBanking::FundsTransferByCustomerService.configure do |config|
  config.environment = ybl_uat
end

ApiBanking::InstantMoneyTransferService.configure do |config|  
  config.environment = qg_aws
end

ApiBanking::SinglePayment.configure do |config|  
  config.environment = rbl_uat
end

ApiBanking::DomesticRemittanceByPartnerService.configure do |config|  
  config.environment = qg_aws
end

ApiBanking::NotificationService.configure do |config|
  config.proxy = "10.211.55.2:8080"
  config.environment = qg_aws
end

ApiBanking::InstantCreditService.configure do |config|
  config.environment = qg_aws
end

ApiBanking::PrepaidCardManagementService.configure do |config|
  config.proxy = "10.211.55.2:8080"
  config.environment = qg_aws
end
