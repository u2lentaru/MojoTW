package TestWork::Controller::List;
use warnings;
use strict;
use Mojo::Base 'Mojolicious::Controller', -signatures;
use Mojo::Pg;
use Mojo::UserAgent;

our $urlid = 0;
our $urlname = "";

sub list ($self) {
  $self->render(template => 'list/list');
}

sub showadd ($self) {
  $self->render(template => 'list/add');
}

sub saveadd ($self) {
    my $newurl = $self->param('nu');
    my $ts = localtime(time);
    
    my $ua  = Mojo::UserAgent->new;
    my $res_ora = $ua->insecure(1)->get($newurl);
    my ($hst, $hhl, $hhc, $hhs) = (" ", " ", " ", " ");

    if (defined ($res_ora->original_remote_address)) {
      my $res = $ua->insecure(1)->get($newurl)->result;
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
    my $res_ora = $ua->insecure(1)->get($newurl);
    my ($hst, $hhl, $hhc, $hhs) = (" ", " ", " ", " ");

    if (defined ($res_ora->original_remote_address)) {
      my $res = $ua->insecure(1)->get($newurl)->result;
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
  # my $ca = $ua->ca;
  # $ua = $ua->ca('/twapp/crt/ca.crt');
  # my $cert = $ua->cert;
  # $ua = $ua->cert('/twapp/crt/client.crt');
 
    foreach my $rec (@{$self->pg->db->query('select id, url from url_list')->hashes->to_array}) {
      my $newurl = $rec->{url};
      my $id = $rec->{id};

      my $ts = localtime(time);
    
      my $res_ora = $ua->insecure(1)->get($newurl);
      my ($hst, $hhl, $hhc, $hhs) = (" ", " ", " ", " ");

      if (defined ($res_ora->original_remote_address)) {
        my $res = $ua->insecure(1)->get($newurl)->result;
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
    };

    $self->redirect_to("/"); 
    
}

1;