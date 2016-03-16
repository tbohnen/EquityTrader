#
# Equity Trader
# Note, no security has been added as yet and some ports like mongo is exposed!
#
#

# Pull base image.
FROM dockerfile/ubuntu
MAINTAINER Theo Bohnen "theo@codeitright.co.za"

# Define working directory.
WORKDIR /etc/EquityTrader

# Expose ports.
EXPOSE 80
EXPOSE 443
#Mongo
EXPOSE 27017
EXPOSE 28017


# Install MongoDB.
RUN \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && \
  echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' > /etc/apt/sources.list.d/mongodb.list && \
  apt-get update && \
  apt-get install -y mongodb-org && \
  rm -rf /var/lib/apt/lists/*

# Define mountable directories.
VOLUME ["/data/db"]

# Install Ruby
RUN \
  apt-get update && \
  apt-get install -y ruby ruby-dev ruby-bundler && \
  rm -rf /var/lib/apt/lists/*

# Define command that runs when machine is started
CMD ["bash"]


# Install Nginx.
# RUN \
#   add-apt-repository -y ppa:nginx/stable && \
#   apt-get update && \
#   apt-get install -y nginx && \
#   rm -rf /var/lib/apt/lists/* && \
#   echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
#   chown -R www-data:www-data /var/lib/nginx

# Define mountable directories.
# VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]


# Define default command.
# CMD ["nginx"]
