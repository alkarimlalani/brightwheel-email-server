describe "API::Validator" do
  context "#invalid_request?" do
    before(:each) do
      @payload = {
        to: 'fake@example.com',
        to_name: 'Mr. Fake',
        from: 'noreply@mybrightwheel.com',
        from_name: 'Brightwheel',
        subject: 'A Message from Brightwheel',
        body: '<h1>Your Bill</h1><p>$10</p>'
      }
    end

    context "valid payload" do
      it "should return false" do
        expect(invalid_request?).to eq(false)
      end
    end

    context "missing key" do
      it "should return true" do
        @payload.delete :to
        expect(invalid_request?).to eq(true)
      end
    end

    context "given invalid email" do
      it "returns true when email isn't valid" do
        @payload[:to] = 'hello'
        expect(invalid_request?).to eq(true)
      end
    end
  end

  context "#valid_key?" do
    it "returns false for unknown key type" do
      expect(valid_key? :other, nil).to eq(false)
    end
    it "returns true for valid string" do
      expect(valid_key? :string, 'hi').to eq(true)
    end
    it "returns true for valid email" do
      expect(valid_key? :email, 'hi@hello.com').to eq(true)
    end
  end

  it "has a defined EXPECTED_PARAMS constant" do
    expect(API::Validator::EXPECTED_PARAMS).not_to eq(nil)
  end
end