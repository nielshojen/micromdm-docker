#!/bin/sh

echo "Waiting to make sure storage is up"

sleep 30

# Make sure we have the needed folders
if [[ ${MICROMDM_CONFIG_DIR} ]]; then
  mkdir -p ${MICROMDM_CONFIG_DIR}
fi

if [[ ${MICROMDM_CERTS_DIR} ]]; then
  mkdir -p ${MICROMDM_CERTS_DIR}
fi

if [[ ${MICROMDM_REPO_DIR} ]]; then
  mkdir -p ${MICROMDM_REPO_DIR}
fi


execServe="/usr/local/bin/micromdm serve -server-url=${MICROMDM_SERVER_URL} -filerepo ${MICROMDM_REPO_DIR} -config-path ${MICROMDM_CONFIG_DIR}"

# add psql connection
if [[ ${PG_HOST} ]] && [[ ${PG_USER} ]] && [[ ${PG_PASS} ]] && [[ ${PG_DBNAME} ]]; then
  execServe="${execServe} psql --host=${PG_HOST} --port=5432 --username=${PG_USER} --dbname=${PG_DBNAME} --password=${PG_PASS}"
fi

# add api key if specified
if [[ ${API_KEY} ]]; then
  execServe="${execServe} -api-key ${API_KEY}"
fi

# set TLS
if [[ ${TLS} = true ]]; then
  execServe="${execServe} -tls"
else
  execServe="${execServe} -tls=false"
fi

if [[ ${TLS_CERT} ]] && [[ ${TLS_KEY} ]]; then
  execServe="${execServe} -tls-cert '${TLS_CERT}' -tls-key '${TLS_KEY}'"
fi

# set HTML
if [[ "${HOMEPAGE}" = "false" ]]; then
  execServe="${execServe} -homepage=false"
fi

# set webhook
if [[ ${WEBHOOK_URL} ]]; then
  execServe="${execServe} -command-webhook-url ${WEBHOOK_URL}"
fi

#set debug
if [[ ${DEBUG} ]]; then
  execServe="${execServe} -http-debug"
fi

echo "Starting using: $execServe"

$execServe &