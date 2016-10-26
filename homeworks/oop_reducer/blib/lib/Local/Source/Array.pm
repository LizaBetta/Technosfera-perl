package Local::Source::Array;

use strict;
use warnings;
use Mouse;
use 5.010;
#use utf8;

extends 'Local::Source';

sub next
{
    my $self = shift;
    state $i = 0;
    if ($i != length($self->{'array'}))
    {
        return $self->{'array'}[$i++];
    }
    else
    {
	    return 'undef';
    }
}


1;
