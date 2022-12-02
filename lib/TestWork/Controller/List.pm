package TestWork::Controller::List;
use warnings;
use strict;
use Mojo::Base 'Mojolicious::Controller', -signatures;
use Mojo::Pg;
use LWP::Simple;
use Mojo::UserAgent;
use Data::Dumper;
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
    $self->pg->db->query('insert into url_list (url, urldate, httpstatus, httphead1, httphead2, httphead3) values (?, null, null, null, null, null)', $newurl);
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
    $self->pg->db->query('update url_list set url = ? where id = ?', $newurl, $id);
    $self->redirect_to("/");
}

sub poll ($self) {
  foreach my $rec (@{$self->pg->db->query('select url from url_list')->hashes->to_array}) {
    my $ua  = Mojo::UserAgent->new;
    my $url = $rec->{url};
    say $url, "\n";
    my $res = $ua->get($url)->res;
    # say Dumper($res->content->headers);
    # say Dumper($res->content->headers{headers});
    say $res->dom->find('h3')->[7];

    # say $res->body;
    # say my $h1 = $res->dom->find('head')->[0];
    # if ($res->is_success)  { say $res->body } 
    # if ($res->is_success)  
    # { say $res->dom->find('title')->[0]};
    # $ua->get('http://url.ru')->res->dom->find('h1')->[0];   
  };    
    $self->redirect_to("/"); 
}


1;
