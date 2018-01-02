FROM mysql:latest
 
RUN apt-get update
RUN apt-get install -y locales
RUN rm -rf /var/lib/apt/lists/*
ENV LC_ALL ja_JP.UTF-8
 
ADD ./docker/mysql/charset.cnf /etc/mysql/conf.d/charset.cnf
