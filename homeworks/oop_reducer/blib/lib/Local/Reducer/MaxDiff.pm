package Local::Reducer::MaxDiff;

use strict;
use warnings;
use diagnostics;
use Mouse;
#use utf8;

extends 'Local::Reducer';


has top =>
(
    is => "ro",
);

has bottom =>
(
    is => "ro",
);

sub _reduce_one
{
    my ($self) = @_;
    if((my $str = $self->{'source'}->next) ne 'undef')
    {
        my $row = $self->{'row_class'}->new('str' => $str,);
        my $elem1 = $row->get($self->{'bottom'}, 0);
        my $elem2 = $row->get($self->{'top'}, 0);
        my $diff = $elem2 - $elem1;
        if($diff > $self->{'reduced'})
        {
            $self->{'reduced'} = $diff;
        }
        return 1;
    }
    else {return 0}
}

1;
