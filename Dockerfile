# Use the redhattraining/httpd-parent image as base
FROM quay.io/wcheng/httpd-parent

# Change the port to 8080
EXPOSE 8080

# Labels consumed by OpenShift
LABEL io.k8s.description="A basic Apache HTTP Server child image, uses ONBUILD" \
      io.k8s.display-name="Apache HTTP Server" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="apache, httpd"

# Change web server port to 8080
RUN sed -i "s/Listen 80/Listen 8080/g" /etc/httpd/conf/httpd.conf

# Permissions to allow container to run on OpenShift
RUN chgrp -R 0 /var/log/httpd /var/run/httpd && \
    chmod -R g=u /var/log/httpd /var/run/httpd

RUN  yum install -y python2 && ln -s /usr/bin/python2 /usr/bin/python

ADD https://people.redhat.com/wcheng/mail.py /tmp
RUN chmod 777 /tmp/mail.py

# Run as a non-privileged user
USER 1001
