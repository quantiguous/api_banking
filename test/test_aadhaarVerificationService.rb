require 'minitest_helper'

class TestAadhaarVerificationService < Minitest::Test
  def test_aadhaarVerificationService_exists
    assert ApiBanking::AadhaarVerificationService
  end

  def test_it_gives_back_a_response

    request = ApiBanking::AadhaarVerificationService::Verification::Request.new()
    consumerContext = ApiBanking::AadhaarVerificationService::Verification::ConsumerContext.new()
    serviceContext = ApiBanking::AadhaarVerificationService::Verification::ServiceContext.new()
    demographicDataModel = ApiBanking::AadhaarVerificationService::Verification::DemographicDataModel.new()
    getDemoAuthDataReq = ApiBanking::AadhaarVerificationService::Verification::GetDemoAuthDataReq.new()
    reqHdr = ApiBanking::AadhaarVerificationService::Verification::ReqHdr.new()
    reqBody = ApiBanking::AadhaarVerificationService::Verification::ReqBody.new()

    consumerContext.requesterID = 'NEP'
    serviceContext.serviceName = 'EKYCSevice'
    serviceContext.reqRefNum = 'QG001'
    serviceContext.reqRefTimeStamp = '2016-10-10T00:00:00'
    serviceContext.serviceVersionNo = '1.0'
    demographicDataModel.aadhaarName = 'Gayathri Laxmi'
    demographicDataModel.aadhaarNo = '694134418538'
    demographicDataModel.agentID = 'StarKit'
    demographicDataModel.dob = ''

    reqHdr.consumerContext = consumerContext
    reqHdr.serviceContext = serviceContext
    getDemoAuthDataReq.reqHdr = reqHdr
    reqBody.demographicDataModel = demographicDataModel
    getDemoAuthDataReq.reqBody = reqBody
    request.getDemoAuthDataReq = getDemoAuthDataReq

    result = ApiBanking::AadhaarVerificationService.getDemoAuthData(request)
    puts "#{self.class.name} #{result}"
  end
end
