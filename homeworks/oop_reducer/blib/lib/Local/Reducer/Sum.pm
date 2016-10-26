package Local::Reducer::Sum;

use strict;
use warnings;
use diagnostics;
use Mouse;
#use utf8;

extends 'Local::Reducer';

has 'field' =>
(
    is => "ro",
);

sub reduce_n
{
    my ($self, $n) = @_;
    foreach (1..$n)
    {
        my $str = $self->{'source'}->next;
        my $row = $self->{'row_class'}->new(str => $str,);
        my $elem = $row->get($self->{'field'}, 0);
        $self->{'reduced'} = $self->{'reduced'} + $elem;
    }
    return $self->{'reduced'};
}

sub reduce_all
{
    my ($self, $n) = @_;
    while (defined(my $str = $self->{'source'}->next()))
    {
        my $row = $self->{'row_class'}->new('str' => $str);
        my $elem = $row->get($self->{'field'}, 0);
        $self->{'reduced'} = $self->{'reduced'} + $elem;
    }
    return $self->{'reduced'};
}

1;
