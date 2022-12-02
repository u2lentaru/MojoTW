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

# 1
# use strict;
# use warnings 'all';
# use feature 'say';

# use Mojo;

# use constant URL => 'http://stackoverflow.com/questions/tagged/perl';

# STDOUT->autoflush;

# my $ua = Mojo::UserAgent->new;
# my $delay = Mojo::IOLoop::Delay->new;

# my @urls = ( URL ) x 10;

# my @steps =  map {

#     my $url = $_;

#     sub {

#         my $end = $delay->begin;

#         $ua->get( $url => sub {
#             my ( $ua, $txn ) = @_;

#             $end->();

#             if ( my $err = $txn->error ) {
#                 say $err->message;
#             }
#             else {
#                 my $res = $txn->success;
#                 say "@{$res}{qw/ code message /}";
#             }
#         });
#     }

# } @urls;


# $delay->steps( @steps, sub { say 'Done' } );

# Mojo::IOLoop->start unless Mojo::IOLoop->is_running;







# 2
# #!/usr/bin/perl
# use Mojo::Base -strict;

# use Mojo::IOLoop;
# use Mojo::UserAgent;

# my $ua = Mojo::UserAgent->new;

# Mojo::IOLoop->delay(sub {
#   my $delay = shift;
#   $ua->get('https://www.google.ru' => $delay->begin);
# }, sub {
#   my ($delay, $tx) = @_;
#   $tx->res->body; # body of the google.ru
#   $ua->get('https://twitter.com' => $delay->begin);
# }, sub {
#   my ($delay, $tx) = @_;
#   $tx->res->body; # body of the twitter.com
#   warn 'DONE';
# })->wait;

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
