package XMPPManager::Password;

use v5.42.2;
use strict;
use warnings;
use Crypt::URandom qw/urandom/;
use Crypt::Bcrypt qw/bcrypt bcrypt_check/;

use Moo;

sub generate_hash($self, $pass) {
    return bcrypt($pass, '2b', 14, urandom(16));
}

sub check($self, $pass, $hash) {
    return bcrypt_check($pass, $hash);
}
1;
