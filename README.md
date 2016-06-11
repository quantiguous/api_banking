# ApiBanking

A simple way to get started wit the api's provided by leading banks in India. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'api_banking'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install api_banking

## Usage

You'll need to sign up with your chosen bank to get your credentials. 

Most banks require 3 factors, you'll need a certificate to esablish 2 way trust, and your bank will give you a client id/secret and also a user/password.

## FundsTransferByCustomerService

This service, provided by https://www.yesbank.in/, allows you do to do inter and intra bank transfers (NEFT,RTGS,IMPS) , check the status of a transaction and view your balance.

To operate this service, in a sandbox environment, you need a client id, client secret, and a user/password, these details are available only from the bank.

Once you have them, using the gem makes it simple.


`require 'api_banking'

ApiBanking::FundsTransferByCustomerService.configure do |config|
  config.environment = ApiBanking::Environment::YBL::UAT.new(ENV['API_UAT_USER'], ENV['API_UAT_PASSWORD'], ENV['API_UAT_CLIENT_ID'], ENV['API_UAT_CLIENT_SECRET']  )
end

request = ApiBanking::FundsTransferByCustomerService::GetStatus::Request.new()
request.customerID = '' # your customer id
request.requestReferenceNo = '' # your reference no

puts ApiBanking::FundsTransferByCustomerService.get_status(request)`

## Contributing

1. Fork it ( https://github.com/quantiguous/api_banking/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
