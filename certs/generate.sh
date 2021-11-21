#!/usr/bin/env bash

if [[ $1 = "root" ]]; then
  mkdir -p ./root
  openssl genrsa -out ./root/root-key.pem 4096
  openssl req -new -key ./root/root-key.pem -config ./conf/root.conf -out ./root/root-cert.csr
  openssl x509 -req -days 3650 -signkey ./root/root-key.pem -extensions req_ext -extfile ./conf/root.conf -in ./root/root-cert.csr -out ./root/root-cert.pem
  openssl x509 -in ./root/root-cert.pem -text
	exit 0
fi

if [[ $1 = "istio-cluster" ]]; then
  mkdir -p ./istio-cluster
  openssl genrsa -out ./istio-cluster/istio-cluster-ca-key.pem 4096
  openssl req -new -config ./conf/istio-cluster.conf -key ./istio-cluster/istio-cluster-ca-key.pem -out ./istio-cluster/istio-cluster-ca.csr
  openssl x509 -req -days 730  -CA ./root/root-cert.pem -CAkey ./root/root-key.pem -CAcreateserial \
		-extensions req_ext -extfile ./conf/istio-cluster.conf -in ./istio-cluster/istio-cluster-ca.csr -out ./istio-cluster/istio-cluster-ca-cert.pem
  cat ./istio-cluster/istio-cluster-ca-cert.pem ./root/root-cert.pem > ./istio-cluster/istio-cluster-ca-cert-chain.pem
  openssl x509 -in ./istio-cluster/istio-cluster-ca-cert.pem -text
	exit 0  
fi

if [[ $1 = "wildcard" ]]; then
  mkdir -p ./wildcard
  openssl genrsa -out ./wildcard/wildcard-key.pem 4096
  openssl req -new -config ./conf/wildcard.conf -key ./wildcard/wildcard-key.pem -out ./wildcard/wildcard.csr
  openssl x509 -req -days 730  -CA ./root/root-cert.pem -CAkey ./root/root-key.pem -CAcreateserial \
		-extensions req_ext -extfile ./conf/wildcard.conf -in ./wildcard/wildcard.csr -out ./wildcard/wildcard-cert.pem
  cat ./wildcard/wildcard-cert.pem ./root/root-cert.pem > ./wildcard/wildcard-cert-chain.pem
  openssl x509 -in ./wildcard/wildcard-cert.pem -text
	exit 0
fi

if [[ $1 = "digibank" ]]; then
  mkdir -p ./digibank
  openssl genrsa -out ./digibank/digibank-key.pem 4096
  openssl req -new -config ./conf/digibank.conf -key ./digibank/digibank-key.pem -out ./digibank/digibank.csr
  openssl x509 -req -days 730  -CA ./root/root-cert.pem -CAkey ./root/root-key.pem -CAcreateserial \
		-extensions req_ext -extfile ./conf/digibank.conf -in ./digibank/digibank.csr -out ./digibank/digibank-cert.pem
  cat ./digibank/digibank-cert.pem ./root/root-cert.pem > ./digibank/digibank-cert-chain.pem
  openssl x509 -in ./digibank/digibank-cert.pem -text
	exit 0
fi

if [[ $1 = "clean" ]]; then
  rm -r ./root/* ./istio-cluster/* ./wildcard/* ./digibank/*
	exit 0
fi

echo "please specify action ./generate.sh root/istio-cluster/wildcard/digibank/clean"
exit 1