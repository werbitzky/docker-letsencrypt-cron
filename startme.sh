#!/bin/sh
set -e

OVERRIDE=${OVERRIDE:-}
SKIP_REFRESH=${SKIP_REFRESH:-}
ARGS=${ARGS:-}
CERT_NAME=${CERT_NAME:-}

if [ -z "${OVERRIDE}" ]
then
	mkdir -p /var/www/html
	killall darkhttpd || true
	darkhttpd /var/www/html --port 80 --daemon
	if [ -z "${SKIP_REFRESH}" ]
	then
		wget -qO- https://codeload.github.com/kuba/simp_le/tar.gz/master | tar xz -C /
	fi
	/simp_le-master/simp_le.py --default_root /var/www/html ${ARGS} && cp full.pem /certs/${CERT_NAME}_full.pem
 	killall darkhttpd || true
else
	"$@"
fi
