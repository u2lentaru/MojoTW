#!/usr/bin/env perl
use Mojolicious::Lite;
use Mojo::UserAgent;
use Mojo::Pg;
use Time::timegm;
use Test::Mock::Time;

plugin Cron => (
  '*/5 * * * *' => sub {
    my $target_epoch = shift;
    helper pg => sub { state $pg = Mojo::Pg->new('postgres://postgres:postgres@localhost:5432/postgres') };
    # $self->helper(pg => sub { state $pg = Mojo::Pg->new('postgres://postgres:postgres@localhost:5432/postgres') });
    
    foreach my $rec (@{$pg->db->query('select id, url from url_list')->hashes->to_array}) {
      my $newurl = $rec->{url};
      say "uaurl ", $uaurl;
      my $id = $rec->{id};

      my $ts = localtime(time);
    
      my $ua  = Mojo::UserAgent->new;
      my $res_ora = $ua->get($newurl);
      my ($hst, $hhl, $hhc, $hhs) = (" ", " ", " ", " ");

      # say "original_remote_address ",($res_ora->original_remote_address);
      if (defined ($res_ora->original_remote_address)) {
        my $res = $ua->get($newurl)->result;
        $hst = $res->{code}." ".$res->{message};
        $hhl = $res->headers->location;
        $hhc =  $res->headers->content_type;
        $hhs =  $res->headers->server;
      }
      else {
        $hst = "Cannot resolve host";
        $hhl = "Cannot resolve host";
        $hhc = "Cannot resolve host";
        $hhs = "Cannot resolve host";
      };
        
    $pg->db->query('update url_list set (url, urldate, httpstatus, httphead1, httphead2, httphead3) = (?,?,?,?,?,?) where id = ?', $newurl, $ts, $hst, $hhl, $hhc, $hhs, $id);

    }

  }
);

# for {
#   say localtime(time);
#   sleep(10);
# }

get '/' => sub ($c) {
  $c->render(template => 'index');
};

# ./myapp.pl daemon -l http://*:8080
app->start;