package XMPPManager;

use v5.42.2;
use strict;
use warnings;

use Mojo::Base 'Mojolicious', -signatures;

use XMPPManager::DAO::Admin;

# This method will run once at server start
sub startup ($self) {

    # Load configuration from config file
    my $config = $self->plugin('NotYAMLConfig');

    # Configure the application
    $self->secrets( $config->{secrets} );
    $self->helper(
        user => sub($c) {
            return if !defined $c->session->{username};
            my ($user) = XMPPManager::DAO::Admin->search(
                username => $c->session->{username} );
            return $user if defined $user;
            return;
        }
    );
    push @{ $self->commands->namespaces }, 'XMPPManager::Command';

    # Router
    my $r = $self->routes;
    $r->get('/login')->to('Admin#login');
    $r->post('/login')->to('Admin#validate_login');
    my $after_login = $r->under(
        '/',
        sub ($c) {
			return 1 if defined $c->user;
            $c->redirect_to('/login');
            return undef;
        }
    );
    $after_login->get('/')->to('Domain#list');
    $after_login->get('/domain/:domain')->to('Domain#details');
    $after_login->get('/domain/:domain/create-user')->to('Domain#create_user');
    $after_login->post('/domain/:domain/create-user')->to('Domain#create_user_post');
}
1;
