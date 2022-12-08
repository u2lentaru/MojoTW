#!/usr/bin/perl

use strict;
use warnings;
use Proc::Daemon;
use Mojo::UserAgent;
use Mojo::Pg;

Proc::Daemon::Init;

my $continue = 1;
$SIG{TERM} = sub { $continue = 0 };

my $pg = Mojo::Pg->new('postgres://postgres:postgres@'.$ENV{TW_DB_HOST}.':5432/postgres');

$pg->db->query('CREATE TABLE IF NOT EXISTS public.url_list (
	id int NOT NULL GENERATED ALWAYS AS IDENTITY,
	url text NOT NULL,
  urldate timestamp,
  httpstatus text,
  httphead1 text,
  httphead2 text,
  httphead3 text,
	CONSTRAINT url_list_pk PRIMARY KEY (id)
);');

my $ua  = Mojo::UserAgent->new;

while ($continue) {

    foreach my $rec (@{$pg->db->query('select id, url from url_list')->hashes->to_array}) {
      my $newurl = $rec->{url};
      my $id = $rec->{id};

      my $ts = localtime(time);
    
      my $res_ora = $ua->get($newurl);
      my ($hst, $hhl, $hhc, $hhs) = (" ", " ", " ", " ");

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
    
}