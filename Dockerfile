FROM perl
WORKDIR /opt/myapp
COPY . .
RUN cpanm --installdeps -n .
EXPOSE 3000
CMD ./test_work prefork