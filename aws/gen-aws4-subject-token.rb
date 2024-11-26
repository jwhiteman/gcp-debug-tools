# doesn't work: {"error"=>"invalid_grant", "error_description"=>"The given AWS request doesn't contain all the required headers."}
#
# manually create a signed aws subject token for an sts token exchange

# adapted from the python script here:
# https://cloud.google.com/iam/docs/workload-identity-federation-with-other-clouds#advanced_scenarios

require "pry"
require "json"
require "uri"
require "httparty"
require "aws-sdk-core"

def create_token_aws(project_number, pool_id, provider_id)
  url     = "https://sts.amazonaws.com/?Action=GetCallerIdentity&Version=2011-06-15"
  headers = {
    "Host"                         => "sts.amazonaws.com",
    "x-goog-cloud-target-resource" => "//iam.googleapis.com/projects/#{project_number}/"\
                                      "locations/global/workloadIdentityPools/"\
                                      "#{pool_id}/providers/#{provider_id}"
  }

  credentials = Aws::Credentials.new(
    ENV['AWS_ACCESS_KEY_ID'],
    ENV['AWS_SECRET_ACCESS_KEY'],
  )

  signer = Aws::Sigv4::Signer.new(
    service:     "sts",
    region:      "us-east-1",
    credentials: credentials
  )

  signed_request = signer.sign_request(
    http_method: "POST",
    url:         url,
    headers:     headers,
    body:        nil
  )

  token = {
    url:     url,
    method:  "POST",
    headers: signed_request.headers.map { |key, value| { key: key, value: value } }
  }

  pretty_token  = JSON.pretty_generate(token)
  encoded_token = URI.encode_www_form_component(JSON.generate(token))

  [pretty_token, encoded_token]
end

unless ARGV.length == 3
  puts "usage: PROJECT_NUMBER POOL_ID PROVIDER_ID"
  exit
end

project_number              = ARGV[0]
pool_id                     = ARGV[1]
provider_id                 = ARGV[2]
pretty_token, encoded_token = create_token_aws(project_number, pool_id, provider_id)

binding.pry

response =
  HTTParty.post(
    "https://sts.googleapis.com/v1/token",
    body: {
      audience:             "//iam.googleapis.com/projects/#{project_number}/locations/global/workloadIdentityPools/#{pool_id}/providers/#{provider_id}",
      grant_type:           "urn:ietf:params:oauth:grant-type:token-exchange",
      requested_token_type: "urn:ietf:params:oauth:token-type:access_token",
      scope:                "https://www.googleapis.com/auth/cloud-platform",
      subject_token_type:   "urn:ietf:params:aws:token-type:aws4_request",
      subject_token:        encoded_token
    },
    headers: { "Content-Type" => "application/x-www-form-urlencoded" }
  )

binding.pry
