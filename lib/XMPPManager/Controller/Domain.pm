package XMPPManager::Controller::Domain;

use v5.42.2;
use strict;
use warnings;

use Data::Dumper;

use Mojo::Base 'Mojolicious::Controller', -signatures;

sub list($c) {
    my @domains = $c->_get_domains;
    $c->render( domains => \@domains );
}

sub _get_domains {
    open my $fh, '-|', 'sudo', 'prosodyctl', 'shell', 'host:list()';
    my @domains = <$fh>;
    for my $domain (@domains) {
        chomp $domain;
    }
    pop @domains;
    return @domains;
}

sub _get_domains_hash($c) {
    return map { ( $_ => 1 ) } $c->_get_domains;
}

sub _get_users( $c, $domain ) {
	if ($domain =~ /[^.-a-zA-Z]/) {
		return $c->reply->not_found;
	}
    open my $fh, '-|', 'sudo', 'prosodyctl', 'shell',
      "user:list('$domain')";
    my @users = <$fh>;
    for my $user (@users) {
        chomp $user;
    }
    pop @users;
    return @users;
}

sub details($c) {
    my $domain  = $c->param('domain');
	if ($domain =~ /[^.-a-zA-Z]/) {
		return $c->reply->not_found;
	}
    my %domains = $c->_get_domains_hash;
    return $c->reply->not_found if !defined $domains{$domain};
    my @users = $c->_get_users($domain);
    return $c->render( users => \@users, domain => $domain );
}

sub create_user($c) {
    my $domain  = $c->param('domain');
	if ($domain =~ /[^.-a-zA-Z]/) {
		return $c->reply->not_found;
	}
    my %domains = $c->_get_domains_hash;
    return $c->reply->not_found if !defined $domains{$domain};
    $c->render( domain => $domain );
}

sub create_user_post($c) {
    my $domain   = $c->param('domain');
	if ($domain =~ /[^.-a-zA-Z]/) {
		return $c->reply->not_found;
	}
    my $user     = $c->param('username');
    my $password = $c->param('password');
	if ($user =~ qr{["&'/:<>@]}) {
		return $c->render(text => 'Invalid username', status => 400);
	}
	system 'sudo', 'prosodyctl', 'shell', "user:create('\Q$user\E\@$domain', '\Q$password\E')";
	return $c->redirect_to('/domain/'.$domain);
}
1;
