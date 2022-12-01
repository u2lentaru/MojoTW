package TestWork;
use warnings;
use strict;
use Mojo::Base 'Mojolicious', -signatures;
use Mojo::Pg;
use Mojo::UserAgent;

# This method will run once at server start
sub startup ($self) {

  # Load configuration from config file
  my $config = $self->plugin('NotYAMLConfig');

  # Configure the application
  $self->secrets($config->{secrets});

  $self->helper(pg => sub { state $pg = Mojo::Pg->new('postgres://postgres:postgres@localhost:5432/postgres') });
  # $self->pg->db->query('select version()');

  $self->pg->db->query('CREATE TABLE IF NOT EXISTS public.url_list (
	id int NOT NULL GENERATED ALWAYS AS IDENTITY,
	url text NOT NULL,
  urldate timestamp,
  httpstatus text,
  httphead1 text,
  httphead2 text,
  httphead3 text,
	CONSTRAINT url_list_pk PRIMARY KEY (id)
);');
    
  # Router
  my $r = $self->routes;

  # Normal route to controller
  # $r->get('/')->to('example#welcome');
  $r->get('/')->to('list#list');
  $r->get('/list/')->to('list#list');
  $r->get('/add/')->to('list#showadd');
  $r->post('/add/')->to('list#saveadd');
  $r->get('/del/')->to('list#del');
  $r->get('/upd/')->to('list#showupd');
  $r->post('/upd/')->to('list#saveupd');
  $r->get('/poll/')->to('list#poll');

# Perform operation in 30 seconds
# Mojo::IOLoop->timer(30 => sub ($self->redirect_to("/poll/"));

}

1;

__DATA__
@@ migrations
-- 1 up
CREATE TABLE IF NOT EXISTS public.url_list (
	id int NOT NULL GENERATED ALWAYS AS IDENTITY,
	url text NOT NULL,
  urldate timestamp,
  httpstatus text,
  httphead1 text,
  httphead2 text,
  httphead3 text,
	CONSTRAINT url_list_pk PRIMARY KEY (id)
);
