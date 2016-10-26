package Local::Row::JSON;

use strict;
use warnings;
use Mouse;
#use utf8;

extends 'Local::Row';

sub get
{
    my ($self, $name, $default) = @_;

    use JSON::XS;
    my $res = JSON::XS->new->utf8(1)->decode($self->{'str'});
    if (exists ($res->{$name}) and (defined $res->{$name}))
    {
        return $res->{$name};
    }
    else
    {
        return $default;
    }
}

1;
