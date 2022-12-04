use Mojo::UserAgent;
use Mojo::Server::Daemon;

my $ua = Mojo::UserAgent->new;
my $daemon = Mojo::Server::Daemon->new(
  listen => ['https://*:443']
)->unsubscribe('request');
$daemon->on(request => sub {
  my ($daemon, $tx) = @_;

  my $req = $tx->req->clone;
  $req->url->scheme("https")->host("10.3.199.40");

  $ua->start(Mojo::Transaction::HTTP->new(req => $req) => sub {
    my ($ua, $proxy_tx) = @_;
    $tx->res($proxy_tx->res)->resume;
  });
});
$daemon->run;