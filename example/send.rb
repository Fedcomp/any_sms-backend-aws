#!/usr/bin/env ruby
require "rubygems"
require "bundler/setup"
require "any_sms-backend-aws"
require "pry-byebug"

# Initializer code
AnySMS.configure do |c|
  c.register_backend(
    :my_aws_backend,
    AnySMS::Backend::AWS,
    access_key:        ENV["AWS_ACCESS_KEY"],
    secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
    region:            ENV["AWS_REGION"] # Optional, default will be "us-east-1"
  )

  c.default_backend = :my_aws_backend
end

# Anywhere in your app
text = "some sms text"
resp = AnySMS.send_sms(ENV["MY_PHONE_NUMBER"], text)

# immediate response check
if resp.success?
  puts "Sms should be sent to #{ENV['MY_PHONE_NUMBER']} with text: #{text.inspect}"
else
  # Technically switch is unecessary and
  # provided only in educational purposes
  case resp.status
  when :runtime_error, :sending_failure
    puts "There was error sending sms (#{resp.status}): "
    raise resp.meta[:error]
  end
end
