FROM alpine 

RUN apk --no-cache --update add bash \
  postgresql-client \
  ca-certificates \
  groff \
  less \
  curl \
  && /usr/sbin/addgroup -g 1000 jenkins \ 
  && /usr/sbin/adduser -h /home/jenkins -s /bin/bash -u 1000 -D -G jenkins jenkins

CMD ["bash"]