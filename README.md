# AnySMS::Backend::AWS
[![Build Status](https://travis-ci.org/Fedcomp/any_sms-backend-aws.svg?branch=master)](https://travis-ci.org/Fedcomp/any_sms-backend-aws)

AnySMS backend to send sms using [AWS](https://aws.amazon.com) SNS service.

## Before installation - obtaining token

Before you can use this gem, you should get tokens from amazon web services (AWS).
Here are steps to achieve that:

1. Go to [AWS registration page](https://goo.gl/HG8Y9s)
2. After you registered and logged in, go to [IAM users](https://goo.gl/u4hrzj)
3. Click "Create new users", enter username of your wish (in my case `testuser`) and then click "Create".
4. You should see similar picture:

   ![security credentials](screenshot.png)

   save **access key id** and **secret acces key** somwhere.
5. Now close popup and click on the user.
6. Click **Permissions** tab. It will look like this

   ![permissions tab](permissions_screenshot.png)

7. Click on **Attach Policy**, then filter by **SNS**.
8. Check **AmazonSNSFullAccess**, click **Attach Policy** (at the bottom)

This is simple example on how to get them and make things work quick.
In reality AWS support various access options,
you may read them [here](https://goo.gl/sajJgL) and configure it more strict or closer to your needs.

## Installation & usage

Add this line to your application's Gemfile:

```ruby
gem "any_sms-backend-aws", "~> 1.0"
```

Then somewhere in your initialization code:

```ruby
require "any_sms-backend-aws"

AnySMS.configure do |c|
  c.register_backend(:my_aws_backend,
    AnySMS::Backend::AWS,
    access_key:        ENV["AWS_ACCESS_KEY"],
    secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
    region:            ENV["AWS_REGION"], # Optional, default will be "us-east-1"
    default_sender_id: ENV["AWS_SNS_DEFAULT_SENDER_ID"] # Optional
  )

  c.default_backend = :my_aws_backend
end
```

This is an simple example configuration.
Before running application you should specify
`AWS_ACCESS_KEY`, `AWS_SECRET_ACCESS_KEY`
environment variables.
Optionally you can specify `AWS_REGION`
and `AWS_SNS_DEFAULT_SENDER_ID` (sms sender as text instead of phone).

Keep in mind that `AWS_SNS_DEFAULT_SENDER_ID` is **changing ACCOUNT SETTINGS**,
and is NOT per request. In case you know how to set it per request - please open issue.

!!Make sure **you never commit credentials (secrets) to your repository**!!

Now, whenever you need to send SMS, just do:

```ruby
# Will immediately send sms using AWS sns
AnySMS.send_sms("+10000000000", "My sms text")
```

For more advanced usage please
go to [AnySMS documentation](https://github.com/Fedcomp/any_sms#real-life-example)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Fedcomp/any_sms-backend-aws.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
