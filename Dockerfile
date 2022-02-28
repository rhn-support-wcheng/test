FROM registry.access.redhat.com/ubi8/ubi:latest

MAINTAINER Cheng Wing Kai <wcheng@redhat.com>

# Labels consumed by OpenShift
LABEL io.k8s.description="A basic Apache HTTP Server child image, uses ONBUILD" \
      io.k8s.display-name="Apache HTTP Server" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="apache, httpd"

# DocumentRoot for Apache
ENV DOCROOT=/var/www/html 

# Change the port to 8080
EXPOSE 8080

RUN   curl https://people.redhat.com/wcheng/mail.py > /tmp/mail.py && \
      yum install -y --nodocs --disableplugin=subscription-manager httpd && \
      yum install -y --nodocs --disableplugin=subscription-manager python2 && \
      yum clean all --disableplugin=subscription-manager -y && \
      ln -s /usr/bin/python2 /usr/bin/python && \
      chmod 777 /tmp/mail.py && \
      sed -i "s/Listen 80/Listen 8080/g" /etc/httpd/conf/httpd.conf && \
      echo "Hello from the Kai container!" > ${DOCROOT}/index.html

# Launch httpd
CMD /usr/sbin/httpd -DFOREGROUND
