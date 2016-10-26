package Local::MusicLibrary::Sort;

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

sub compair
{
    my $sort_name = shift;
    if ($sort_name eq 'year')
    {
       $a->{'year'} <=> $b->{'year'};
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
    @$table = sort {compair($sort_name)} @$table;
}
