require "spec_helper"

describe ActiveSms::Backend::AWS do
  it "has a version number" do
    expect(ActiveSms::Backend::AWS::VERSION).not_to be nil
  end
end
