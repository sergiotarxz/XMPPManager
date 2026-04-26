package XMPPManager::Command::create_user;

use v5.42.2;
use strict;
use warnings;

use Mojo::Base 'Mojolicious::Command';

use Mojo::Util qw/getopt/;

use XMPPManager::DAO::Admin;
use XMPPManager::Password;

has description => 'Create a new admin user to manage XMPP users via web';
has usage       => <<"USAGE";
$0 create_user --username <username> --password <password> [--help]
USAGE

sub run( $self, @args ) {
    getopt(
        \@args,
        'u|username=s' => \my $username,
        'p|password=s' => \my $password,
        'h|help'       => \my $help,
    );
    if ($help) {
        say $self->description;
        say $self->usage;
        exit 0;
    }
    if ( !defined $username || !defined $password ) {
        say $self->description;
        say $self->usage;
        exit 200;
    }

    XMPPManager::DAO::Admin->insert(
        XMPPManager::DAO::Admin::Instance->new(
            username => $username,
            password => XMPPManager::Password->generate_hash($password)
        )
    );
	say "Created user $username, remember to vanish password from bash history.";
    exit 0;
}
1;
