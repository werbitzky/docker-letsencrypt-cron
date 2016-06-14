FROM gliderlabs/alpine:3.3

RUN apk --update add python \
		python-dev \
		py-setuptools \
		py-pip \
		openssl-dev \
		openssl \
		musl-dev \
		gcc \
		libffi-dev \
		darkhttpd \
	&& wget -qO- https://codeload.github.com/kuba/simp_le/tar.gz/master | tar xz \
	&& pip install -e /simp_le-master/ \
	&& mkdir /certs \
	&& mkdir /certs_gen \
	&& apk --purge del musl-dev openssl-dev libffi-dev gcc python-dev py-pip

WORKDIR /certs_gen

COPY ["./startme.sh", "/usr/local/bin/"]
COPY root /var/spool/cron/crontabs/root

CMD /usr/local/bin/startme.sh && crond -l 2 -f
