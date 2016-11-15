package Local::Habr::Base;

use strict;
use warnings;

use Mouse;
use DBI;
 
has dbh =>
(
    is => 'ro',
    builder => '_connect',
);

sub _connect
{
    my $h = DBI->connect("DBI:mysql:habr", 'liza', 'hey');
    return $h;
}


1;






