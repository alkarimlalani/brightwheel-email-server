describe "API::ValidationHelper" do

  context "#valid_string?" do
    it "returns true for valid string" do
      resp = valid_string? 'hi'
      expect(resp).to be(true)
    end
    it "returns false for empty string" do
      resp = valid_string? ''
      expect(resp).to be(false)
    end
    it "returns false for non-string" do
      resp = valid_string? []
      expect(resp).to be(false)
    end
  end

  context "#valid_email?" do
    it "returns true for valid email" do
      resp = valid_string? 'hi@fake.com'
      expect(resp).to be(true)
    end
    it "returns false for invalid email" do
      resp = valid_email? 'hi@.com'
      expect(resp).to be(false)
    end
    it "returns false for non-string" do
      resp = valid_email? []
      expect(resp).to be(false)
    end
  end

end