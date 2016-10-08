package Local::Filter;

use strict;
use warnings;
use diagnostics;

=encoding utf8

=head1 NAME

Local::Table - core music library module

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

sub filter
{
    my ($filter_type, $filter_name, $str) = @_;
    if ($str->{$filter_type} eq $filter_name)
    {
        return true;
    }
    else
    {
        return false;
    }
}
