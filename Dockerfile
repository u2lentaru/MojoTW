FROM ubuntu:latest
RUN mkdir /twapp
WORKDIR /twapp
COPY . .
RUN apt-get update
RUN apt-get install -y gnupg2
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 871920D1991BC93C
RUN apt install
RUN apt install make
RUN apt-get install libproc-daemon-perl -y
RUN apt-get install libconfig-simple-perl
RUN apt-get install libdbi-perl
RUN apt-get install libdbd-pg-perl -y
RUN apt-get install libpq-dev -y
RUN apt-get install libio-socket-ssl-perl -y
RUN cpan -T Proc::Daemon
RUN cpan -T IO::Socket::SSL
RUN cpan -T Mojo::UserAgent
RUN cpan -T Mojo::Pg
RUN cpan -T Mojo::Base
EXPOSE 3000
ENTRYPOINT ["/bin/sh"]
CMD ["./start_script.sh"]