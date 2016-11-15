package Local::Habr::Base::PostsTable;

use strict;
use warnings;
use FindBin '$Bin';
use lib "$Bin/../../..";

use Mouse;
use DBI;

extends 'Local::Habr::Base';

sub set
{
    my ($self, $post) = @_;
    my $sql = "SELECT id FROM post WHERE id=?";
    my $sth = $self->{dbh}->prepare($sql);
    if ($sth->execute($post->{id}) != 0)
    {
        $sql = "UPDATE post SET author=?, topic=?, rating=?,
                    views=?, stars=? WHERE id=?";
        $sth = $self->{dbh}->prepare($sql);
    }
    else
    {
        $sql = "INSERT INTO post VALUES(?, ?, ?, ?, ?, ?)";
        $sth = $self->{dbh}->prepare($sql);
    }
    $sth->execute($post->{author}, $post->{theme},
                    $post->{rating}, $post->{views}, 
                    $post->{stars}, $post->{id});
}


1;
