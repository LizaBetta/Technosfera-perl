package Local::Row::Simple;

use strict;
use warnings;
use Mouse;
#use utf8;

extends 'Local::Row';

sub get
{
    my ($self, $name, $default) = @_;
    foreach($self->{'str'})
    {
        if (/\s*${name}\s*:\s*([^,]+)/)
        {
            return $1;
        }
        else
        {
            return $default;
        }
    }
}

1;
