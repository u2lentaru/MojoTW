FROM perl
RUN mkdir /opt/twapp
WORKDIR /opt/twapp
COPY . .
RUN cpanm --installdeps -n .
EXPOSE 3000
CMD ./test_work prefork