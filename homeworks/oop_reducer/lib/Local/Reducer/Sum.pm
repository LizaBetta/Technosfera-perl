package Local::Reducer::Sum;

use strict;
use warnings;
use diagnostics;
use Mouse;
#use utf8;

extends 'Local::Reducer';

has field =>
(
    is => "ro",
);

sub _reduce_one
{
    my ($self) = @_;
    if(defined(my $str = $self->{'source'}->next))
    {
       my $row = $self->{'row_class'}->new('str' => $str,);
       my $elem = $row->get($self->{'field'}, 0);
       $self->{'reduced'} +=  $elem;
       return 1;
    }
    else { return 0 }
}

1;
