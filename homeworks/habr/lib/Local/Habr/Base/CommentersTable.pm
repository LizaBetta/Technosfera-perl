package Local::Habr::Base::CommentersTable;

use strict;
use warnings;
use FindBin '$Bin';
use lib "$Bin/../../..";

use Mouse;
use DBI;

extends 'Local::Habr::Base';

sub set
{
    my ($self, $post, $user) = @_;
    my $sql = "INSERT INTO commenters VALUES(?, ?)";
    my $stmt = $self->{dbh}->prepare($sql);
    $stmt->execute($user, $post);
}

1;
