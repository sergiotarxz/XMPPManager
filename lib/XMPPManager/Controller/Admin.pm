package XMPPManager::Controller::Admin;

use v5.42.2;
use strict;
use warnings;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use XMPPManager::DAO::Admin;
use XMPPManager::Password;

sub login($c) {
    return $c->render(msg => 'hola mundo');
}

sub validate_login($c) {
	my $username = $c->param('username');
	my $password = $c->param('password');
	my ($user) = @{XMPPManager::DAO::Admin->search(username => $username)};
	if (!defined $user) {
		return $c->redirect_to('/login');
	}
	if (!XMPPManager::Password->check($password, $user->password)) {
		return $c->redirect_to('/login');
	}
	$c->session({username => $username});
	return $c->redirect_to('/');
}
1;
