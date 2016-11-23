require 'minitest_helper'

class NotificationService < Minitest::Test

  def test_it_gives_back_zero_topics
    VCR.use_cassette('NotificationService_getTopics_returns_zero_topics') do
      criteria = ApiBanking::NotificationService::GetTopics::ReqCriteria.new()
      subscriber = ApiBanking::NotificationService::GetTopics::Subscriber.new()
      request = ApiBanking::NotificationService::GetTopics::Request.new()

      subscriber.customerID = '1234'
      subscriber.subscribed = 'true'
      criteria.topicGroup = 'abc'
      criteria.subscriber = subscriber

      request.appID = 'app1212'
      request.criteria = criteria

      topicsResult = ApiBanking::NotificationService.getTopics(NotificationServiceEnvironment, request)
      puts "#{self.class.name} : #{topicsResult}"
      assert_equal topicsResult[:topicsArray], nil
    end
  end
    
  def test_it_gives_back_one_topic
    VCR.use_cassette('NotificationService_getTopics_returns_one_topic') do
      criteria = ApiBanking::NotificationService::GetTopics::ReqCriteria.new()
      subscriber = ApiBanking::NotificationService::GetTopics::Subscriber.new()
      request = ApiBanking::NotificationService::GetTopics::Request.new()

      subscriber.customerID = '12345'
      subscriber.subscribed = 'true'
      criteria.topicGroup = 'bal'
      criteria.subscriber = subscriber

      request.appID = 'app1212'
      request.criteria = criteria

      topicsResult = ApiBanking::NotificationService.getTopics(NotificationServiceEnvironment, request)
      puts "#{self.class.name} : #{topicsResult}"
      refute_equal topicsResult[:topicsArray][:topic][0], nil
    end
  end
  
  def test_it_gives_back_multiple_topics
    VCR.use_cassette('NotificationService_getTopics_returns_multiple_topics') do
      criteria = ApiBanking::NotificationService::GetTopics::ReqCriteria.new()
      subscriber = ApiBanking::NotificationService::GetTopics::Subscriber.new()
      request = ApiBanking::NotificationService::GetTopics::Request.new()

      subscriber.customerID = '12345'
      subscriber.unsubscribed = 'true'
      criteria.topicGroup = 'bal'
      criteria.subscriber = subscriber

      request.appID = 'app1212'
      request.criteria = criteria

      topicsResult = ApiBanking::NotificationService.getTopics(NotificationServiceEnvironment, request)
      puts "#{self.class.name} : #{topicsResult}"
      refute_equal topicsResult[:topicsArray][:topic].count, 1
    end
  end
  
  def test_it_gives_back_topic_with_criteriaDefinitionArray
    VCR.use_cassette('NotificationService_getTopics_topic_with_criteriaDefinitionArray') do
      criteria = ApiBanking::NotificationService::GetTopics::ReqCriteria.new()
      subscriber = ApiBanking::NotificationService::GetTopics::Subscriber.new()
      request = ApiBanking::NotificationService::GetTopics::Request.new()

      subscriber.customerID = '12345'
      subscriber.unsubscribed = 'true'
      criteria.topicGroup = 'bal'
      criteria.subscriber = subscriber

      request.appID = 'app1212'
      request.criteria = criteria

      topicsResult = ApiBanking::NotificationService.getTopics(NotificationServiceEnvironment, request)
      puts "#{self.class.name} : #{topicsResult}"
      assert_equal topicsResult[:topicsArray][:topic][1][:criteriaDefinitionArray][:criteriaDefinition].count, 1
    end
  end
  
  def test_it_gives_back_topic_without_criteriaDefinitionArray_and_subscription
    VCR.use_cassette('NotificationService_getTopics_topic_without_criteriaDefinitionArray_and_subscription') do
      criteria = ApiBanking::NotificationService::GetTopics::ReqCriteria.new()
      subscriber = ApiBanking::NotificationService::GetTopics::Subscriber.new()
      request = ApiBanking::NotificationService::GetTopics::Request.new()

      subscriber.customerID = '12345'
      subscriber.unsubscribed = 'true'
      criteria.topicGroup = 'bal'
      criteria.subscriber = subscriber

      request.appID = 'app1212'
      request.criteria = criteria

      topicsResult = ApiBanking::NotificationService.getTopics(NotificationServiceEnvironment, request)
      puts "#{self.class.name} : #{topicsResult}"
      assert_equal topicsResult[:topicsArray][:topic][0][:criteriaDefinitionArray], nil
      assert_equal topicsResult[:topicsArray][:topic][0][:subscription], nil
    end
  end
  
  def test_it_gives_back_topic_with_subscription_without_criteria
    VCR.use_cassette('NotificationService_getTopics_returns_topic_with_subscription_without_criteria') do
      criteria = ApiBanking::NotificationService::GetTopics::ReqCriteria.new()
      subscriber = ApiBanking::NotificationService::GetTopics::Subscriber.new()
      request = ApiBanking::NotificationService::GetTopics::Request.new()

      subscriber.customerID = '12345'
      # subscriber.unsubscribed = 'true'
      subscriber.subscribed = 'true'
      criteria.topicGroup = 'bal'
      criteria.subscriber = subscriber

      request.appID = 'app1212'
      request.criteria = criteria

      topicsResult = ApiBanking::NotificationService.getTopics(NotificationServiceEnvironment, request)
      puts "#{self.class.name} : #{topicsResult}"
      assert_equal topicsResult[:topicsArray][:topic][0][:subscription][:criteriaArray][:criteria], []
    end
  end
  
  def test_it_gives_back_topic_with_subscription_with_criteria
    VCR.use_cassette('NotificationService_getTopics_returns_topic_with_subscription_with_criteria') do
      criteria = ApiBanking::NotificationService::GetTopics::ReqCriteria.new()
      subscriber = ApiBanking::NotificationService::GetTopics::Subscriber.new()
      request = ApiBanking::NotificationService::GetTopics::Request.new()

      subscriber.customerID = '2727'
      subscriber.subscribed = 'true'
      criteria.topicGroup = 'fd'
      criteria.subscriber = subscriber

      request.appID = 'app1212'
      request.criteria = criteria

      topicsResult = ApiBanking::NotificationService.getTopics(NotificationServiceEnvironment, request)
      puts "#{self.class.name} : #{topicsResult}"
      refute_equal topicsResult[:topicsArray][:topic][0][:subscription][:criteriaArray][:criteria].count, 0
    end
  end

  def test_it_gives_back_a_setSubscription_result
    request = ApiBanking::NotificationService::SetSubscription::Request.new()
    subscriber = ApiBanking::NotificationService::SetSubscription::Subscriber.new()
    contact = ApiBanking::NotificationService::SetSubscription::Contact.new()

    criteriaArray = ApiBanking::NotificationService::SetSubscription::CriteriaArray.new()
    criteria = ApiBanking::NotificationService::SetSubscription::Criteria.new()
    value = ApiBanking::NotificationService::SetSubscription::Value.new()
    value.decimalValue = '1000'

    criteria.name = 'lessthan'
    criteria.value = value
    criteriaArray.criteria = criteria

    contact.emailID = 'abc@example.com'
    contact.mobileNo = '9876543210'

    subscriber.customerID = '123456'
    subscriber.accountNo = '1234567890'
    subscriber.contact = contact

    request.version = '1'
    request.appID = 'app1212'
    request.topicName = 'balabcealert'
    request.notifyByEmail = false
    request.notifyBySMS = true
    request.subscriber = subscriber
    request.criteriaArray = criteriaArray

    puts "#{self.class.name} : #{ApiBanking::NotificationService.setSubscription(NotificationServiceEnvironment, request)}"
  end

  def test_it_gives_back_a_deleteSubscription_result
    request = ApiBanking::NotificationService::DeleteSubscription::Request.new()
    subscriber = ApiBanking::NotificationService::DeleteSubscription::Subscriber.new()

    subscriber.customerID = '123456'
    subscriber.accountNo = '1234567890'

    request.version = '1'
    request.appID = 'app1212'
    request.topicName = 'balabcealert'
    request.subscriber = subscriber

    puts "#{self.class.name} : #{ApiBanking::NotificationService.deleteSubscription(NotificationServiceEnvironment, request)}"
  end

  def test_it_gives_back_a_sendMessage_result
    request = ApiBanking::NotificationService::SendMessage::Request.new()
    recipient = ApiBanking::NotificationService::SendMessage::Recipient.new()
    subscriber = ApiBanking::NotificationService::SendMessage::Subscriber.new()
    contact = ApiBanking::NotificationService::SendMessage::Contact.new()

    mergeVarArray = ApiBanking::NotificationService::SendMessage::MergeVarArray.new()
    mergeVar = ApiBanking::NotificationService::SendMessage::MergeVar.new()
    content = ApiBanking::NotificationService::SendMessage::Content.new()

    criteriaArray = ApiBanking::NotificationService::SendMessage::CriteriaArray.new()
    criteria = ApiBanking::NotificationService::SendMessage::Criteria.new()
    criteriaValue = ApiBanking::NotificationService::SendMessage::Value.new()

    contact.emailID = 'abc@example.com'
    contact.mobileNo = '9876543210'

    subscriber.customerID = '2828'
    subscriber.accountNo = '77887766889966'
    subscriber.contact = contact

    recipient.subscriber = subscriber

    content.dateContent = '2016-07-15'

    mergeVar.name = 'Customer1'
    mergeVar.content = content
    mergeVarArray.mergeVar = mergeVar

    criteria.name = 'lessthan'
    criteriaValue.decimalValue = '10000'
    criteria.value = criteriaValue
    criteriaArray.criteria = criteria

    request.version = '1'
    request.appID = 'app1212'
    request.topicName = 'moneydebited'
    request.recipient = recipient

    request.mergeVarArray = mergeVarArray
    request.criteriaArray = criteriaArray
    request.referenceNo = SecureRandom.uuid.gsub!('-','')
    request.sendAt = '2016-07-17T09:00:00'

    puts "#{self.class.name} : #{ApiBanking::NotificationService.sendMessage(NotificationServiceEnvironment, request)}"
  end

  def test_it_gives_back_a_dispatchMessage_result
    request = ApiBanking::NotificationService::DispatchMessage::Request.new()
    recipient = ApiBanking::NotificationService::DispatchMessage::Recipient.new()
    subscriber = ApiBanking::NotificationService::DispatchMessage::Subscriber.new()
    contact = ApiBanking::NotificationService::DispatchMessage::Contact.new()

    criteriaArray = ApiBanking::NotificationService::DispatchMessage::CriteriaArray.new()
    criteria = ApiBanking::NotificationService::DispatchMessage::Criteria.new()
    criteriaValue = ApiBanking::NotificationService::DispatchMessage::Value.new()

    message = ApiBanking::NotificationService::DispatchMessage::Message.new()
    email = ApiBanking::NotificationService::DispatchMessage::Email.new()

    contact.emailID = 'abc@example.com'
    contact.mobileNo = '9876543210'

    subscriber.customerID = '2828'
    subscriber.accountNo = '77887766889966'
    subscriber.contact = contact

    recipient.subscriber = subscriber

    criteria.name = 'lessthan'
    criteriaValue.decimalValue = '10000'
    criteria.value = criteriaValue
    criteriaArray.criteria = criteria

    message.smsText = 'test12'
    email.subject = 'Test Email'
    email.bodyContent = 'Hi, This is test email.'
    message.email = email

    request.version = '1'
    request.appID = 'app1212'
    request.topicName = 'moneydebited'
    request.recipient = recipient

    request.criteriaArray = criteriaArray
    request.message = message
    request.referenceNo = SecureRandom.uuid.gsub!('-','')
    request.sendAt = '2016-07-17T09:00:00'

    puts "#{self.class.name} : #{ApiBanking::NotificationService.dispatchMessage(NotificationServiceEnvironment, request)}"
  end
  
end