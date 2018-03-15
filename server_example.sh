#!/bin/bash

echo "Sending a request"
curl -H "Content-Type: application/json" -X POST \
	-d '{"to":"alkarim.lalani@gmail.com", "to_name":"Alkarim Lalani", "from":"noreply@sandbox1681ccff4c3645d2a832b2a8bde3ce73.mailgun.org", "from_name":"Brightwheel", "subject":"A message from Brightwheel", "body":"<h1>Your Bill</h1><p>$10</p>"}' \
	http://localhost:4567/email