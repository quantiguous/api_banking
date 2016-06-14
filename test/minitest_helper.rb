$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'api_banking'

require 'minitest/autorun'
require 'securerandom'

Typhoeus::Config.verbose = false

ybl_uat = ApiBanking::Environment::YBL::UAT.new(ENV['API_UAT_USER'], ENV['API_UAT_PASSWORD'], ENV['API_UAT_CLIENT_ID'], ENV['API_UAT_CLIENT_SECRET']  )
rbl_uat = ApiBanking::Environment::RBL::UAT.new(ENV['API_RBL_UAT_USER'], ENV['API_RBL_UAT_PASSWORD'], ENV['API_RBL_UAT_CLIENT_ID'], ENV['API_RBL_UAT_CLIENT_SECRET'], ENV['API_RBL_UAT_CLIENT_CERT'], ENV['API_RBL_UAT_CLIENT_KEY']  )
ybl_prd = ApiBanking::Environment::YBL::PRD.new(ENV['API_USER'], ENV['API_PASSWORD'], ENV['API_CLIENT_ID'], ENV['API_CLIENT_SECRET'], ENV['API_CLIENT_CERT'], ENV['API_CLIENT_KEY'])

ApiBanking::FundsTransferByCustomerService2.configure do |config|  
  config.environment = ybl_uat
end

ApiBanking::FundsTransferByCustomerService.configure do |config|
  config.environment = ybl_uat
end

ApiBanking::InstantMoneyTransferService.configure do |config|  
  config.environment = ybl_uat
end

ApiBanking::SinglePayment.configure do |config|  
  config.environment = rbl_uat
end
