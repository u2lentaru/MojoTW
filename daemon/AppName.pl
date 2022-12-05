#!/usr/bin/env perl
use Mojolicious::Lite -signatures;
use Mojo::UserAgent;
use Mojo::Pg;

get '/' => sub ($c) {
  $c->render(template => 'index');
};

my $ts = localtime(time);

  # helper(pg => sub { state $pg = Mojo::Pg->new('postgres://postgres:postgres@localhost:5432/postgres') });
  my $pg = Mojo::Pg->new('postgres://postgres:postgres@localhost:5432/postgres');
  say $pg->db->query('select version() as version')->hash->{version};


for (1) {
    say $ts;
    
    foreach my $rec (@{$pg->db->query('select id, url from url_list')->hashes->to_array}) {
      my $newurl = $rec->{url};
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
    };

    sleep(300);
};

app->start;

__DATA__

@@ index.html.ep
% layout 'default';
% title 'Welcome';
<h1>Welcome to the Mojolicious real-time web framework!</h1>
<%= localtime(time) %>

@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
  <head><title><%= title %></title></head>
  <body><%= content %></body>
</html>

