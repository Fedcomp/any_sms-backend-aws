require "spec_helper"
require "any_sms/backend/aws"

describe AnySMS::Backend::AWS do
  it "has a version number" do
    expect(AnySMS::Backend::AWS_VERSION).not_to be nil
  end

  describe ".send_sms" do
    # initialization args
    let(:access_key) { "XXXXXXXXXXXXXXXXXXXX" }
    let(:secret_access_key) { "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" }
    let(:region) { "us-east-1" }

    # send_sms args
    let(:phone_number) { "+10000000000" }
    let(:text) { "sms text" }

    subject do
      described_class.new access_key: access_key,
                          secret_access_key: secret_access_key,
                          region: region
    end

    let(:mocked_client) { Aws::SNS::Client.new(stub_responses: true) }

    before do
      expect(Aws::SNS::Client).to receive(:new).and_return(mocked_client)
    end

    it "responds to success? on successful sending" do
      expect(subject.send_sms(phone_number, text)).to be_success
    end

    context "on failure" do
      before do
        # imitate failure on current implementation
        expect_any_instance_of(Aws::SNS::Types::PublishResponse)
          .to receive(:message_id).and_return(nil)
      end

      it "responds to failed?" do
        expect(subject.send_sms(phone_number, text)).to be_failed
      end

      it "returns :unknown_failure status" do
        expect(subject.send_sms(phone_number, text).status).to eq(:unknown_failure)
      end
    end
  end
end
