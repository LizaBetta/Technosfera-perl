package Local::Sort;

use strict;
use warnings;
use diagnostics;

=encoding utf8

=head1 NAME

Local::Sort - core music library module

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

sub w
{
    my $sort_name = shift;
    if ($sort_name eq 'year')
    {
        my $x = $a;
        my $y = $b;
        0 + $x->{'year'} <=> 0 + $y->{'year'};
    }
    else
    {
        $a->{$sort_name} cmp $b->{$sort_name};
    }
}

sub sort_table
{
    my $table = shift;
    my $sort_name = shift;
    @$table = sort {w($sort_name)} @$table;
}
