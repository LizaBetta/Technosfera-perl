package Local::Source::Text;

use warnings;
use strict;
use Mouse;
use 5.010;
#use utf8;

extends 'Local::Source';

sub next
{
    my $self = shift;    
    state $position = 0;
    if($position != length($self->{'text'}))
    {
        pos($self->{'text'}) = $position;
        $self->{'text'} =~ /\G([^\n]*)\n?/gc;
        $position = pos($self->{'text'});
        return $1;   
    }
    return 'undef';
}


1;
