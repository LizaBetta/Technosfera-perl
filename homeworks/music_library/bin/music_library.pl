use 5.010;
use strict;
use warnings;
use diagnostics;

use FindBin '$Bin';
use lib "$Bin/../lib";

use Local::Table;
use Local::Sort;
use Local::Filter;

sub read_args
{
    my ($name_sort, $name_filter, $order, $type_filter) = @_;
    my $arg = shift @ARGV;
    if($arg eq '--sort')
    {
         $$name_sort   = shift @ARGV;
    }
    elsif($arg eq '--columns')
    {
        my $x = shift(@ARGV);
        @$order = split (/\,/, $x);
    }
    else
    {
        $$type_filter = $arg;
        $$type_filter =~ s/-+//;
        $$name_filter = shift @ARGV; 
    }
}

my $sort_name;
my $filter_type = 'filter';
my $filter_name;
my @order = ('band', 'year', 'album', 'track', 'format');
my @table;
my %col_width = ( 'band' => 2,
              'year' => 2,
              'album' => 2,
              'track' => 2,
              'format' => 2);
while(@ARGV != 0)
{
    read_args(\$sort_name, \$filter_name, \@order, \$filter_type);
}
while (<>) 
{
    if (length($_) != 0)
    {
        Local::Filter::push_str($_, \@table, \%col_width, $filter_type, $filter_name);
    }
}

if( scalar(@table) != 0)
{
    if(defined($sort_name))
    {
        Local::Sort::sort_table(\@table, $sort_name);
    }
    Local::Table::print_table(\@table, \%col_width, \@order);
}



1;
