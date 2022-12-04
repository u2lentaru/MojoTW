package TestWork::Controller::List;
# use warnings;
use strict;
use Mojo::Base 'Mojolicious::Controller', -signatures;
use Mojo::Pg;
use LWP::Simple;
use Mojo::UserAgent;
use Data::Dumper;
use Mojo::IOLoop::Delay;
use Mojo::Transaction;

our $urlid = 0;
our $urlname = "";

sub list ($self) {
  # foreach my $rec (@{$pg->db->query('select * from url_list')->hashes->to_array}) {
  #   $tbl .="<tr><td>".$rec->{id}."</td>"."<td>".$rec->{url}."</td>"."<td>".$rec->{urldate}."</td>"."<td>".$rec->{httpstatus}.
  #   "</td>"."<td>".$rec->{httphead1}."</td>"."<td>".$rec->{httphead2}."</td>"."<td>".$rec->{httphead3}."</td></tr>"
  # }
   
  $self->render(template => 'list/list');
}


sub showadd ($self) {
  $self->render(template => 'list/add');
}

sub saveadd ($self) {
    my $newurl = $self->param('nu');
    my $ts = localtime(time);
    
    my $ua  = Mojo::UserAgent->new;
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

    $self->pg->db->query('insert into url_list (url, urldate, httpstatus, httphead1, httphead2, httphead3) values (?, ?, ?, ?, ?, ?)', $newurl, $ts, $hst, $hhl, $hhc, $hhs);
    $self->redirect_to("/");   
}

sub del ($self) {
    my $oldid = $self->param('id');
    $self->pg->db->query('delete from url_list where id = ?', $oldid);
    $self->redirect_to("/");
}

sub showupd ($self) {
  $urlid = $self->param('id');
  $urlname = $self->param('url');
  $self->render(template => 'list/upd', urlname=>$urlname);
}

sub saveupd ($self) {
    my $id = $urlid;
    my $newurl = $self->param('nu');
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

    $self->pg->db->query('update url_list set (url, urldate, httpstatus, httphead1, httphead2, httphead3) = (?,?,?,?,?,?) where id = ?', $newurl, $ts, $hst, $hhl, $hhc, $hhs, $id);
    $self->redirect_to("/");
}

sub poll ($self) {
  my $ua  = Mojo::UserAgent->new;
 
  foreach my $rec (@{$self->pg->db->query('select id, url from url_list')->hashes->to_array}) {
    my $uaurl = $rec->{url};
    say "uaurl ", $uaurl;
    my $uaurlid = $rec->{id};
    # say "uaurlid ", $uaurlid, "\n";

    my $res = $ua->get($uaurl)->result;
    # say $res->{message};
    # say $res->{code};
    say "@{$res}{qw/ code message /}";
    # say $res->dom->at('title')->text;
    # say Dumper($res->headers);
    if ($res->headers->location){
    say $res->headers->location;}
    else {say ""};
    say $res->headers->content_type;
    say $res->headers->server;
    # say $res->headers;
  #  };
  };    

    $self->redirect_to("/"); 
}


1;
