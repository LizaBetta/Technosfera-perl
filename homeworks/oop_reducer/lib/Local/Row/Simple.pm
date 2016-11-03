package Local::Row::Simple;

use strict;
use warnings;
use Mouse;
#use utf8;

extends 'Local::Row';
   
sub _build_struct
{
    my ($self) = @_;
    my $h;
    foreach($self->{str})
    {
        while (/\G\s*([^:\s]+)\s*:\s*([^,]+),*/gc)
        {
            $h->{$1} = $2;
        }
    }
    return $h;
}

1;
