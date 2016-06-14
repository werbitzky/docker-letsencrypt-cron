#!/bin/sh
set -e

OVERRIDE=${OVERRIDE:-}
SKIP_REFRESH=${SKIP_REFRESH:-}
ARGS=${ARGS:-}

while [ "$1" != "" ]; do
	PARAM=`echo $1 | awk -F= '{print $1}'`
	VALUE=`echo $1 | awk -F= '{print $2}'`
	case $PARAM in
    -d)
      DOMAIN=$VALUE
      exit
      ;;
    *)
      ;;
	esac
	shift
done

if [ -z "${OVERRIDE}" ]
then
	mkdir -p /var/www/html
	darkhttpd /var/www/html --port 80 --daemon
	if [ -z "${SKIP_REFRESH}" ]
	then
		wget -qO- https://codeload.github.com/kuba/simp_le/tar.gz/master | tar xz -C /
	fi
	/simp_le-master/simp_le.py --default_root /var/www/html ${ARGS} && mv full.pem /certs/${DOMAIN}_full.pem
else
	"$@"
fi
