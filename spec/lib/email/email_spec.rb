describe "Email class" do
  before(:each) do
    @html = "<h1>Your Bill</h1><p>$10</p>"
    @text = "Your Bill $10"
  end

  context "#to_plain_text" do
    it "converts html to plain text" do
      email = Email.new({})
      ret = email.send :to_plain_text, @html
      expect(ret).to eq(@text)
    end
  end

  context "#set_email_content!" do
    it "modifies the email content" do
      email = Email.new({body: @html})
      expect(email.instance_variable_get(:@email_hash)[:html]).to eq(@html)
      expect(email.instance_variable_get(:@email_hash)[:text]).to eq(@text)
    end
  end

  context "sets email adapter" do
    it "shoulld set a default" do
      email = Email.new({})
      expect(email.instance_variable_get(:@email_adapter)).not_to eq(nil)
    end
    it "sets mailgun" do
      ENV['EMAIL_PROVIDER'] = 'mailgun'
      email = Email.new({})
      expect(email.instance_variable_get(:@email_adapter)).to eq(Email::Adapters::Mailgun)
    end
    it "sets mandrill" do
      ENV['EMAIL_PROVIDER'] = 'mandrill'
      email = Email.new({})
      expect(email.instance_variable_get(:@email_adapter)).to eq(Email::Adapters::Mandrill)
    end
  end
end