describe "Email Service" do
  before(:each) do
    @payload = {
      to: 'fake@example.com',
      to_name: 'Mr. Fake',
      from: 'noreply@mybrightwheel.com',
      from_name: 'Brightwheel',
      subject: 'A Message from Brightwheel',
      body: '<h1>Your Bill</h1><p>$10</p>'
    }.to_json
  end

  context "/email route" do
    it "should accept a POST request" do
      post '/email', @payload, { 'CONTENT_TYPE' => 'application/json' }
      expect(last_response).to be_ok
    end

    it "should not accept a GET request" do
      get '/email', @payload, { 'CONTENT_TYPE' => 'application/json' }
      expect(last_response.status).to be(400)
    end

    it "returns JSON error when bad request" do
      get '/email', @payload, { 'CONTENT_TYPE' => 'application/json' }
      expect(last_response.content_type).to eq("application/json")
      expect(last_response.body).to eq({error: "Missing key: body"}.to_json)
    end
  end

  context "send via mailgun" do
    it "should return a valid response" do
      ENV['EMAIL_PROVIDER'] = 'mailgun'
      resp = {"email_provider":"mailgun",
              "status":"queued",
              "id":"<20180315163303.1.E54A5226F65693EB@sandbox1681ccff4c3645d2a832b2a8bde3ce73.mailgun.org>"
             }.to_json
      post '/email', @payload, { 'CONTENT_TYPE' => 'application/json' }
      expect(last_response.body).to eq(resp)
    end
  end

  context "send via mandrill" do
    it "should return a valid response" do
      ENV['EMAIL_PROVIDER'] = 'mandrill'

      # Re-stub RestClient to respond with sample Mandrill API response
      RestClient ||= double
      response = double
      allow(response).to receive(:code).and_return(200)
      allow(response).to receive(:body).and_return("[{\"email\":\"alkarim.lalani@gmail.com\",\"status\":\"queued\",\"_id\":\"56e07b1d9dc94d4092fcb10604916a02\",\"reject_reason\":null}]")
      allow(RestClient).to receive(:post).and_return(response)

      resp = {"email_provider":"mandrill",
              "status":"queued",
              "id":"56e07b1d9dc94d4092fcb10604916a02"
             }.to_json
      post '/email', @payload, { 'CONTENT_TYPE' => 'application/json' }
      expect(last_response.body).to eq(resp)
    end
  end
end