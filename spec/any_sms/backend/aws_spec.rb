require "spec_helper"
require "any_sms/backend/aws"

describe AnySMS::Backend::AWS do
  it "has a version number" do
    expect(AnySMS::Backend::AWS_VERSION).not_to be nil
  end

  describe "#send_sms" do
    # initialization args
    let(:access_key) { "XXXXXXXXXXXXXXXXXXXX" }
    let(:secret_access_key) { "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" }
    let(:region) { "us-east-1" }
    let(:default_sender_id) { "test_sender" }

    # send_sms args
    let(:phone_number) { "+10000000000" }
    let(:text) { "sms text" }

    subject(:instance) do
      described_class.new access_key: access_key,
                          secret_access_key: secret_access_key,
                          region: region,
                          default_sender_id: default_sender_id
    end

    let(:mocked_client) { Aws::SNS::Client.new(stub_responses: true) }

    before do
      expect(Aws::SNS::Client).to receive(:new).and_return(mocked_client)
    end

    it "set default_sender_id" do
      expect(mocked_client).to receive(:set_sms_attributes)
        .with(attributes: { "DefaultSenderID" => default_sender_id })

      subject.send_sms(phone_number, text)
    end

    context "on success" do
      it "responds to success?" do
        expect(subject.send_sms(phone_number, text)).to be_success
      end
    end

    context "on failure" do
      context "when AWS return remote error" do
        before do
          # imitate failure on current implementation
          allow_any_instance_of(Aws::SNS::Types::PublishResponse)
            .to receive(:message_id)
        end

        it "responds to .failed?" do
          expect(subject.send_sms(phone_number, text)).to be_failed
        end

        it "is not .success?" do
          expect(subject.send_sms(phone_number, text)).not_to be_success
        end

        it "returns :sending_failure .status" do
          expect(subject.send_sms(phone_number, text).status).to eq(:sending_failure)
        end
      end

      context "when RuntimeError was raised" do
        let(:expected_args) do
          { phone_number: "", message: "sms text" }
        end

        let(:exception) { StandardError.new("Whatever could happen") }

        before do
          expect(mocked_client).to receive(:publish).with(expected_args) do
            raise exception
          end
        end

        subject { instance.send_sms("", text) }

        it "responds to .failed?" do
          expect(subject).to be_failed
        end

        it "is not .success?" do
          expect(subject).not_to be_success
        end

        it "returns :runtime_error .status" do
          expect(subject.status).to eq(:runtime_error)
        end

        it "hold exception object in .meta[:error]" do
          expect(subject.meta[:error]).to be(exception)
        end
      end
    end
  end
end
