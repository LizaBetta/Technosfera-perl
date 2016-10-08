package Local::give_table;

use strict;
use warnings;

=encoding utf8

=head1 NAME

Local::give_table - core music library module

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

sub give_table
{
    my $data = "./Dreams Of Sanity/1999 - ".#shift;
               "Masquerade/Lost Paradise '99.mp3"
    
    $data ~= m{
        ^
        \. /
        (?<band>[^/]+)
        /
        (?<year>\d+)
        \s+ - \s+
        (?<album>[^/]+)
        /
        (?<track>.+)
        \.
        (?<format>[^\.]+)
    }x;
    
    print $data;
}

1;






