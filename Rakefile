namespace :proxy do
  desc "proxy up"
  task :up do
    sh "gcloud config set proxy/type http_no_tunnel"
    sh "gcloud config set proxy/address localhost"
    sh "gcloud config set proxy/port 8080"
    sh "gcloud config set core/custom_ca_certs_file ~/.mitmproxy/mitmproxy-ca-cert.pem"
  end

  desc "proxy down"
  task :down do
    sh "gcloud config unset proxy/type"
    sh "gcloud config unset proxy/address"
    sh "gcloud config unset proxy/port"
    sh "gcloud config unset core/custom_ca_certs_file"
  end

  desc "show proxy status"
  task :status do
    sh "gcloud config list proxy/type"
    sh "gcloud config list proxy/address"
    sh "gcloud config list proxy/port"
    sh "gcloud config list core/custom_ca_certs_file"
  end
end
