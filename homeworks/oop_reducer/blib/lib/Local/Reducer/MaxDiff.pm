package Local::Reducer::MaxDiff;

use strict;
use warnings;
use diagnostics;
use Mouse;
#use utf8;

extends 'Local::Reducer';


has 'top' =>
(
    is => "ro",
);

has 'bottom' =>
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
        my $elem1 = $row->get($self->{'bottom'}, 0);
        my $elem2 = $row->get($self->{'top'}, 0);
        my $diff = $elem2 - $elem1;
        if($diff > $self->{'reduced'})
        {
            $self->{'reduced'} = $diff;
        }
    }
    return $self->{'reduced'};
}

sub reduce_all
{
    my ($self, $n) = @_;
    while ((my $str = $self->{'source'}->next) ne 'undef')
    {
        my $row = $self->{'row_class'}->new('str' => $str,);
        my $elem1 = $row->get($self->{'bottom'}, 0);
        my $elem2 = $row->get($self->{'top'}, 0);
        my $diff = $elem2 - $elem1;
        if($diff > $self->{'reduced'})
        {
            $self->{'reduced'} = $diff;
        }
    }
    return $self->{'reduced'};
}

1;
