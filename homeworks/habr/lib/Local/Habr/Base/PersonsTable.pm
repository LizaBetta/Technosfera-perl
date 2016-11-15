package Local::Habr::Base::PersonsTable;

use strict;
use warnings;
use FindBin '$Bin';
use lib "$Bin/../../..";

use Mouse;
use DBI;

extends 'Local::Habr::Base';

sub set
{
    my ($self, $user) = @_;
    my $sql = "SELECT nik FROM person WHERE nik=?";
    my $sth = $self->{dbh}->prepare($sql);
    if($sth->execute($user->{name}) != 0)
    {
        $sql = "UPDATE person SET karma=?, rating=?, 
                author_of=? WHERE nik=?";   
        $sth = $self->{dbh}->prepare($sql);
        $sth->execute($user->{karma}, $user->{rating}, 
                        $user->{author_of}, $user->{name});
    }
    else
    {
        $sql = "INSERT INTO person VALUES(?, ?, ?, ?)";
        $sth = $self->{dbh}->prepare($sql);
        $sth->execute($user->{name}, $user->{karma},
            $user->{rating}, $user->{author_of});
    }
}

1;
