package XMPPManager::DB;

use v5.42.2;
use strict;
use warnings;

use DBIx::Auto::Migrate;

finish_auto_migrate;

sub config_dir {
    return $ENV{HOME} . '/.xmppmanager';
}

sub dsn {
    my $class = shift;
	system mkdir => '-pv', $class->config_dir;
    return "dbi:SQLite:dbname=@{[$class->config_dir]}/db.sqlite";
}

sub user {
    return undef;
}

sub pass {
    return undef;
}

sub extra {
    return { PrintError => 1, Callbacks => {}};
}

sub migrations {
    return (
        'CREATE TABLE options (
            id BIGSERIAL PRIMARY KEY,
            name TEXT,
            value TEXT,
            UNIQUE (name)
        )',
        create_index(qw/options name/),
        'CREATE TABLE admins (
            id BIGSERIAL PRIMARY KEY,
            username TEXT NOT NULL,
            password TEXT NOT NULL,
            UNIQUE (username)
        )',
        create_index(qw/admins username/),
    );
}

sub create_index {
    my ( $table, $column ) = @_;
    if ( !$table ) {
        die 'Index requires table';
    }
    if ( !$column ) {
        die 'Index requires column';
    }
    return "CREATE INDEX index_${table}_${column} ON $table ($column)";
}
1;
