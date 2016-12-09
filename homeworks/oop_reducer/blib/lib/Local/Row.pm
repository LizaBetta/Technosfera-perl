package Local::Row;

use strict;
use warnings;
use Mouse;
#use utf8;	

has str =>
(
    is => 'ro',
);

has struct =>
(
    is => 'rw',
    builder => '_build_struct',
);

sub get
{
    my ($self, $name, $default) = @_;
    if (exists ($self->{struct}->{$name}) and 
                    (defined $self->{struct}->{$name}))
    {
        return $self->{struct}->{$name};
    }
    else
    {
        return $default;
    }
}

1;
