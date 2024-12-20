# Dockerfile for Debian 11 setup

# Use Debian 11 as the base image
FROM debian:11

# Set non-interactive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# Update and upgrade system
RUN apt-get update && apt-get upgrade -y

# Install Apache2 and PHP
RUN apt-get install apache2 -y && \
    apt install php libapache2-mod-php -y && \
    systemctl restart apache2

# Install build tools
RUN apt-get update && apt-get install -y \
    build-essential automake

# Download and extract thelinkbox
WORKDIR /home
RUN wget https://github.com/wd5m/misc/raw/master/thelinkbox-compiled-debian9.tgz && \
    tar xvzf thelinkbox-compiled-debian9.tgz

# Setup scripts and permissions
WORKDIR /home/thelinkbox/scripts
RUN chmod +x tlbevent.sh

# Download configuration file
WORKDIR /home/thelinkbox
RUN wget http://texomarepeatergroup.com/TheLinkBox/tlb.conf

# Download, extract, and build thelinkbox source
WORKDIR /
RUN wget --no-check-certificate https://github.com/wd5m/thelinkbox/archive/master.tar.gz && \
    tar zxvf master.tar.gz

WORKDIR /thelinkbox-master
RUN ./bootstrap.sh && \
    ./configure && \
    make && \
    make install

# Add and execute the startup script
COPY startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

# Set the default command to execute the startup script
CMD ["/usr/local/bin/startup.sh"]

# Default working directory
WORKDIR /home/thelinkbox
