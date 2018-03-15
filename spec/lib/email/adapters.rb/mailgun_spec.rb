describe "Email::Adapters::Mailgun" do
  before(:all) do
    @adapter = Email::Adapters::Mailgun
  end

  it "has a send_email method" do
    @adapter.methods.include? :send_email
  end

  context ".send_email" do
    it "can send emails" do
      resp = @adapter.send_email(
        to: 'fake@example.com',
        to_name: 'Mr. Fake',
        from: 'noreply@mybrightwheel.com',
        from_name: 'Brightwheel',
        subject: 'A Message from Brightwheel',
        html: '<h1>Your Bill</h1><p>$10</p>',
        text: 'Your Bill $10'
      )

      json_resp = {"email_provider":"mailgun",
                   "status":"queued",
                   "id":"<20180315163303.1.E54A5226F65693EB@sandbox1681ccff4c3645d2a832b2a8bde3ce73.mailgun.org>"
                  }
      expect(resp).to eq(json_resp)
    end

  end

end