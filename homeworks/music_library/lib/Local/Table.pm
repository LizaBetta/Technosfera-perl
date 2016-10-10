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


sub print_table
{
    my ($table, $width, $order) = @_;
    my $table_width = scalar(@$order) + 1;#учитываем перегородки
    my $t_rows = scalar(@$table);
    if($t_rows == 0 or @$order == 0){ return; }
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
}

1;
