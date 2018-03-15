describe "Email::Adapters::Mandrill" do
  before(:all) do
    @adapter = Email::Adapters::Mandrill
  end

  it "has a send_email method" do
    @adapter.methods.include? :send_email
  end

  context ".send_email" do
    it "can send emails" do
      RestClient ||= double
      response = double
      allow(response).to receive(:code).and_return(200)
      allow(response).to receive(:body).and_return("[{\"email\":\"alkarim.lalani@gmail.com\",\"status\":\"queued\",\"_id\":\"56e07b1d9dc94d4092fcb10604916a02\",\"reject_reason\":null}]")
      allow(RestClient).to receive(:post).and_return(response)

      resp = @adapter.send_email(
        to: 'fake@example.com',
        to_name: 'Mr. Fake',
        from: 'noreply@mybrightwheel.com',
        from_name: 'Brightwheel',
        subject: 'A Message from Brightwheel',
        html: '<h1>Your Bill</h1><p>$10</p>',
        text: 'Your Bill $10'
      )

      json_resp = {"email_provider":"mandrill",
                   "status":"queued",
                   "id":"56e07b1d9dc94d4092fcb10604916a02"
                  }
      expect(resp).to eq(json_resp)
    end

  end

end