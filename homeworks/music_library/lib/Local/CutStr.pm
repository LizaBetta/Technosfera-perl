package Local::CutStr;

use strict;
use warnings;
use diagnostics;

=encoding utf8

=head1 NAME

Local::CutStr - core music library module

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut


sub cut_str
{
    my $data = shift;
    
    $data =~ m{
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
        (?<format>[^\n\.]+$)
    }x;
    return %+;
1;}






1;
