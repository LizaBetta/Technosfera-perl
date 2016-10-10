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

sub max_width
{
    my ($str, $width) = @_;
    my $keys;
    my $value;
    while (($keys, $value) = each %$str)
    {
        if(length($value) + 2 > $width->{$keys})
        {
            $width->{$keys} = length($value) + 2;
        }
    }
}
    

sub filter
{
    my ($str, $filter_name, $filter_type) = @_;
    if (defined($filter_name))
    {
        if ($filter_type eq 'year')
        {
            if ($str->{$filter_type} != $filter_name)
            {
                return 1;
            }
        }
        elsif ($str->{$filter_type} ne $filter_name)
        {
            return 1;
        }
    } 
    return 0;
}

sub push_str
{
    my ($data, $table, $col_width, $filter_type, $filter_name) = @_;
    my %str = Local::CutStr::cut_str($data);
    if(filter(\%str, $filter_name, $filter_type)) { return 0; }
    max_width(\%str, $col_width);
    if (@{$table} != 0)
    { 
        %{ $table -> [ $#{$table} + 1 ] } = %str; 
    }
    else
    {
         %{ $table -> [ 0 ] } = %str;
    }
    return $table;
} 

