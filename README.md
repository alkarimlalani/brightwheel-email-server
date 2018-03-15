# Brightwheel Email Server

## How to install the application
1. Clone the repo from: https://github.com/alkarimlalani/brightwheel-email-server
2. `cd` into the repo
3. Run `bundle install`

## How to test the application
1. From inside the repo you can simply run `rspec`
2. Or you can run the server via `ruby app.rb` and then send some sample server requests to it, I have a file you can run via `./server_example.sh`

## Architecture + Discussion
### Guiding Principles
As I wrote the app, the guiding principles were:
- Build a service thats super simple thats easy to maintain and extend - this will allow us to move fast in the future and for anyone to work on the service
- Build for the user - since this is an internal service, I sought to build it for the person consuming it, i.e. developers on the Brightwheel team

### Language + Framework
- I used Ruby since that's what I'm most productive in
- I used Sinatra instead of Rails since we have only a simple route and didn't need any of the overhead of Rails (for example, we don't even have a database for this task)

### Validation
- Validation of the task is done in a before hook, so all the API Request validation happens before any logic is performed. If we were to add authentication, we would add it here as well
- The validation library is meant to be helpful: it checks both that the values are present and formatted correctly and tells the developer/client if that isn't the case.
- The API Validation isn't harsh on the user, for example it doesn't punish you if you send extra parameters. This is done on purpose because since this is an internal service, we don't expect malicious usage.

### Sending Emails
- The way you send an email is by instantiating an Email object and call the `deliver` method. The email object will at instantiation time decide which email provider to user.
- You can change the email provider by changing the `EMAIL_PROVIDER` environment value.  
- The way the Email class sets the adapter is by choosing an Adapter module for the specified email provider. I took advantage of the fact that everything is an object in Ruby, including modules, so the `deliver` method has no idea what module it is calling the `send_email` method on, as long as the method exists on the module's singleton class, everyone is happy.
- How to extend and add more email providers: If you wanted to also send email via Sendgrid, you could add a Sendgrid email adapter file at `email/adapter/sendgrid.rb` that has a `send_email` method. Then just update the case statement in `Email#initialize`  to choose the Sendgrid adapter when `ENV['EMAIL_PROVIDER']` is `sendgrid` and then go ahead and change the env variable for `EMAIL_PROVIDER` to `sendgrid`.

### Processing Email Body
- To create a text version of the email, I simply convert the HTML to an HTML doc via `nokogiri` to get valid HTML. Then I simply remove the tags and add spaces between the tags. This is done inside the Email class in the `to_plain_text` method.

### Testing
- Given that this is an internal tool and not a public API, there aren't too many adversarial tests (i.e. tests for malicious usage, reasons why it would fail)
- I also sought to prioritize high leverage tests. There are certain methods that don't have direct tests because they are indirectly tested by other methods, for example `Email::Adapter::Mandrill#format_response` isn't tested explicitly, because it is implicitly tested when I check the response values for the `send_email` method in that module. I believe this prioritization of tests is important when you want to be able to move fast.
- Even though not every method is directly tested, there is 100% code coverage that we were able to achieve by prioritizing higher leverage tasks (I set up a code coverage gem to confirm).

### What we could do to extend this in the future
- Sending emails can be slow if the provider API is responding slowly. Sometimes its best to put that as a background job. We could set up `resque` and process emails in the background, retry a few times with exponential backoff if sending emails fails the first time, and then update the client via a `callback_url` that was passed in the client request about the email status.
- We could also do automatic failovers, if Mailgun failed to send the email, we could try again to send the email via Mandrill. The Email class could iterate over all the adapters until the email succeeds. This would save us the need to even respond to outages caused by email providers.

### Other
- Note: I've included my .env in this repo so you can test the app easily, this is not something I would do in a production setting.
- Documentation: There is a convention amongst Ruby programmers that if your code is easily understandable by reading it, then you shouldn't document it because it is redundant. I've provided documentation where I thought necessary but otherwise I thought the code was easy to read.
