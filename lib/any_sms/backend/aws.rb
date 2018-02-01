require "aws-sdk"
require "any_sms"
require "any_sms/backend/aws/version"

# AnySMS backend class to send sms using amazon web services
class AnySMS::Backend::AWS < AnySMS::Backend::Base
  # To use class, you need access key from AWS.
  # Go to README for instructions on how to obtain them.
  #
  # @param access_key [String] AWS access key
  # @param secret_access_key [String] AWS secret access key
  # @param region [String] AWS region. Full list: https://goo.gl/Ys5XMi
  # @param default_sender_id [String] Default SenderID, !CHANGES account settings!
  def initialize(access_key:, secret_access_key:, region: "us-east-1",
                 default_sender_id: nil)
    @access_key = access_key
    @secret_access_key = secret_access_key
    @region = region
    @default_sender_id = default_sender_id
  end

  # Sends sms using amazon web services
  #
  # @phone [String] Phone number in E.164 format
  # @text  [String] Sms text
  def send_sms(phone, text, _args = {})
    resp = sns_client.publish(phone_number: phone, message: text)

    if resp.error.nil? && resp.message_id
      respond_with_status :success
    else
      respond_with_status :sending_failure, meta: { error: resp.error }
    end
  rescue StandardError => e
    respond_with_status :runtime_error, meta: { error: e }
  end

  protected

  def sns_client
    @client ||= begin
      client = Aws::SNS::Client.new(sns_options)

      unless @default_sender_id.nil?
        client.set_sms_attributes(attributes: { "DefaultSenderID" => @default_sender_id })
      end

      client
    end
  end

  def sns_options
    {
      access_key_id: @access_key,
      secret_access_key: @secret_access_key,
      region: @region
    }
  end
end
