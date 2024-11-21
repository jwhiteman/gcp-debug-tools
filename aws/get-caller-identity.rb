# this doesn't work yet...

# https://docs.aws.amazon.com/STS/latest/APIReference/API_GetCallerIdentity.html
# https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_sigv-troubleshooting.html

require "cgi"
require "json"
require "httparty"
require "pry"

subject_token = SOME_SUBJECT_TOKEN

subject_token = JSON.parse(CGI.unescape(subject_token))

authorization        = subject_token["headers"][0]["value"]
x_amz_date           = subject_token["headers"][2]["value"]
x_amz_security_token = subject_token["headers"][3]["value"]
host                 = subject_token["headers"][1]["value"]


headers = {
  "Host"                 => host,
  "Accept-Encoding"      => "identity",
  "X-Amz-Date"           => x_amz_date,
  "User-Agent"           => "aws-cli/1.10.0 Python/2.7.3 Linux/3.13.0-79-generic botocore/1.3.22",
  "X-Amz-Security-Token" => x_amz_security_token,
  "Content-Type"         => "application/x-www-form-urlencoded",
  "Authorization"        => authorization
}

body = {
  "Action"  => "GetCallerIdentity",
  "Version" => "2011-06-15"
}

response = HTTParty.post(
  "https://sts.amazonaws.com",
  headers: headers,
  body: URI.encode_www_form(body)
)

puts response.body
