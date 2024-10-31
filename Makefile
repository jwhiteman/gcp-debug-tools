.PHONY: proxy-up proxy-down proxy-status

proxy-up:
	gcloud config set proxy/type http_no_tunnel
	gcloud config set proxy/address localhost
	gcloud config set proxy/port 8080
	gcloud config set core/custom_ca_certs_file ~/.mitmproxy/mitmproxy-ca-cert.pem

proxy-down:
	gcloud config unset proxy/type
	gcloud config unset proxy/address
	gcloud config unset proxy/port
	gcloud config unset core/custom_ca_certs_file

proxy-status:
	gcloud config list proxy/type
	gcloud config list proxy/address
	gcloud config list proxy/port
	gcloud config list core/custom_ca_certs_file
