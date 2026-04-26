package XMPPManager::DAO::Admin;

use v5.42.2;
use strict;
use warnings;

use DBIx::Quick;

use XMPPManager::DB;

table 'admins';

field id => ( is => 'ro', search => 1, pk => 1 );
field username => ( is => 'ro', search => 1, required => 1 );
field password => ( is => 'ro', required => 1 );
fix;

sub dbh {
	return XMPPManager::DB->connect;
}
1;
