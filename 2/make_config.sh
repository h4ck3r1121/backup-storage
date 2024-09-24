#!/bin/bash

read -p "Введите уникальное имя на латинице для последующей идентификации: " unique_name

# В source_keys находятся ca.crt и ta.key

SOURCE_KEYS_DIR=~/clients/source_keys
KEYS_DIR=~/clients/$unique_name/keys
OUTPUT_DIR=~/clients/$unique_name/files
BASE_CONFIG=~/clients/base.conf

mkdir -p $KEYS_DIR
mkdir -p $OUTPUT_DIR

~/easy-rsa/easyrsa gen-req $unique_name nopass

cp ~/easy-rsa/pki/private/$unique_name.key $KEYS_DIR

~/easy-rsa/easyrsa sign-req client $unique_name

cp ~/easy-rsa/pki/issued/$unique_name.crt $KEYS_DIR

cat ${BASE_CONFIG} \
    <(echo -e '<ca>') \
    ${SOURCE_KEYS_DIR}/ca.crt \
    <(echo -e '</ca>\n<cert>') \
    ${KEYS_DIR}/${unique_name}.crt \
    <(echo -e '</cert>\n<key>') \
    ${KEYS_DIR}/${unique_name}.key \
    <(echo -e '</key>\n<tls-crypt>') \
    ${SOURCE_KEYS_DIR}/ta.key \
    <(echo -e '</tls-crypt>') \
    > ${OUTPUT_DIR}/$unique_name.ovpn
