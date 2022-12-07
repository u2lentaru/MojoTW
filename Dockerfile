FROM ubuntu
RUN mkdir /twapp
WORKDIR /twapp
COPY . .
RUN apt-get update
RUN apt install
RUN apt install make
RUN apt-get install libproc-daemon-perl -y
RUN apt-get install libconfig-simple-perl
RUN apt-get install libdbi-perl
RUN apt-get install libdbd-pg-perl -y
RUN apt-get install libpq-dev -y
RUN cpan -T Proc::Daemon
RUN cpan -T Mojo::UserAgent
RUN cpan -T Mojo::Pg
RUN cpan -T Mojo::Base
EXPOSE 3000
ENTRYPOINT ["/bin/sh"]
CMD ["./start_script.sh"]