#!/bin/sh

execServe="/micromdm serve -server-url='${SERVER_URL}' -filerepo /repo -config-path /config"

# add api key if specified
if [[ ${API_KEY} ]]; then
  execServe="${execServe} -api-key ${API_KEY}"
fi

if [[ ${TLS} = true ]]; then
  if [[ ! -z ${TLS_CERT} && ! -z ${TLS_KEY} && -e "/certs/${TLS_CERT}" && -e "/certs/${TLS_KEY}" ]]; then
    execServe="${execServe} -tls-cert '${TLS_CERT}' -tls-key '${TLS_KEY}'"
  fi
else
  execServe="${execServe} -tls=false"
fi

if [[ ${HOMEPAGE} = false ]]; then
  execServe="${execServe} -homepage=false"
fi


if [[ ${DEBUG} ]]; then
  execServe="${execServe} -http-debug"
fi

echo "Starting using: $execServe"

eval $execServe
