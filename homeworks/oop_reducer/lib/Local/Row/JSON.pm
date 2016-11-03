package Local::Row::JSON;

use strict;
use warnings;
use Mouse;
use JSON::XS;
#use utf8;

extends 'Local::Row';

   
sub _build_struct
{
    my ($self) = @_;
    return JSON::XS->new->utf8(1)->decode($self->{'str'}); 
}

1;
