require 'minitest_helper'

class NotificationService < Minitest::Test

  def test_it_gives_back_a_getTopics_result
    
    criteria = ApiBanking::NotificationService::GetTopics::ReqCriteria.new()
    subscriber = ApiBanking::NotificationService::GetTopics::Subscriber.new()
    request = ApiBanking::NotificationService::GetTopics::Request.new()
    
    subscriber.customerID = '12345'
    subscriber.subscribed = 'true'
    # subscriber.unsubscribed = 'true'
    criteria.topicGroup = 'txn'
    criteria.subscriber = subscriber
    
    request.appID = 'app12'
    request.criteria = criteria

    puts "#{self.class.name} : #{ApiBanking::NotificationService.getTopics(request)}"

  end
  
end