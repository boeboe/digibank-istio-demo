#!/usr/bin/env bash

DOMAIN=f5demo.org

if [[ $1 = "root-ca" ]]; then
  openssl genrsa -out root-key.pem 4096
  openssl req -new -key root-key.pem -config root-ca.conf -out root-cert.csr
  openssl x509 -req -days 3650 -signkey root-key.pem -extensions req_ext -extfile root-ca.conf -in root-cert.csr -out root-cert.pem
	exit 0
fi

if [[ $1 = "istio-cluster" ]]; then
  openssl genrsa -out ./istio-cluster/ca-key.pem 4096
  openssl req -new -config ./istio-cluster/intermediate.conf -key ./istio-cluster/ca-key.pem -out ./istio-cluster/ca.csr
  openssl x509 -req -days 730  -CA root-cert.pem -CAkey root-key.pem -CAcreateserial \
		-extensions req_ext -extfile ./istio-cluster/intermediate.conf -in ./istio-cluster/ca.csr -out ./istio-cluster/ca-cert.pem
  cat ./istio-cluster/ca-cert.pem root-cert.pem > ./istio-cluster/cert-chain.pem
	exit 0  
fi

if [[ $1 = "wildcard" ]]; then
  openssl req -out ./wildcard/${DOMAIN}.csr -newkey rsa:4096 -sha512 -nodes -keyout ./wildcard/${DOMAIN}.key -subj "/CN=*.${DOMAIN}/O=F5"
  openssl x509 -req -sha512 -days 3650 -CA root-cert.pem -CAkey root-key.pem -set_serial 0 -in ./wildcard/${DOMAIN}.csr -out ./wildcard/${DOMAIN}.pem
  cat ./wildcard/${DOMAIN}.pem root-cert.pem > ./wildcard/${DOMAIN}-bundle.pem
	exit 0
fi

echo "please specify action ./generate.sh root-ca/cluster/wildcard"
exit 1