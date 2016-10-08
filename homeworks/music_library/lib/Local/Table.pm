package Local::Table;

use strict;
use warnings;
use diagnostics;

use FindBin '$Bin';
use lib "$Bin/../..";


use Local::CutStr;

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
1;}
    
sub filter
{
    my ($str, $filter_name, $filter_type) = @_;
    if (defined($filter_name))
    {
        if ($filter_type eq 'year')
        {
            if (0 + $str->{$filter_type} != $filter_name)
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
1;}

sub print_line
{
    my ($width, $order) = @_;
    print "|";
    foreach my $k (0..$#$order)
    {
        foreach (1..$width->{$order->[$k]})
        {
            print '-';
        }
        if ($k != $#$order)
        {
            print "+";
        }
    }
    print "|\n";
}

sub print_words
{
    my ($str, $width, $order) = @_;
    print '|';
    foreach my $j (@$order)
    {
        my $string = $str->{ $j };
        my $el_width = $width->{ $j };         
        foreach (1 .. $el_width - length($string) - 1)
        {
            print ' ';
        }
        print  "$string |";
    }
    print "\n";
}
sub push_str
{
    my ($data, $table, $col_width, $filter_type, $filter_name) = @_;
    my %str = Local::CutStr::cut_str($data);
    if(filter(\%str, $filter_name, $filter_type)) { return 0; }
    max_width(\%str, $col_width);
    if (scalar(@$table) != 0)
    { 
        %{ $table -> [ $#{$table} + 1 ] } = %str; 
    }
    else
    {
         %{ $table -> [ 0 ] } = %str;
    }
    return $table;
1;} 


sub print_table
{
    my ($table, $width, $order) = @_;
    my $table_width = scalar(@$order) + 1;#учитываем перегородки
    my $t_rows = scalar(@$table);
    if($t_rows == 0 or scalar(@$order) == 0){ return; }
    foreach my $v (@$order)
    {
        $table_width += $width->{$v};
    }
    print '/';
    foreach(2..$table_width - 1){ print "-"; }
    print "\\\n";
    
    foreach my $i (0..$t_rows - 1)
    {
        print_words($table->[$i], $width, $order);
        if($i != $t_rows - 1)
        {
            print_line($width, $order);
        }
    }
    print '\\';
    foreach (2..$table_width - 1){ print "-"; }
    print "/\n";
1;}

1;
