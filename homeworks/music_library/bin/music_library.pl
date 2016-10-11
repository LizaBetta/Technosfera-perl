use 5.010;
use strict;
use warnings;
use diagnostics;

use FindBin '$Bin';
use lib "$Bin/../lib";
use Getopt::Long;

use Local::PrintTable;
use Local::MusicLibrary::Sort;
use Local::MusicLibrary::Filter;

my $sort_name;
my $filter_type;
my $filter_name;
my @order = ('band', 'year', 'album', 'track', 'format');
my $ord;
my @table;
my %col_width = ( 'band' => 2,
              'year' => 2,
              'album' => 2,
              'track' => 2,
              'format' => 2);
sub handler
{
    ($filter_type, $filter_name) = @_;
}

Getopt::Long::GetOptions('album:s'=>  \&handler,
                         'track:s'=> \&handler,
                         'band:s'=> \&handler,
                         'year:s'=> \&handler,
                         'format:s'=> \&handle,
                         'sort:s' => \$sort_name,
                         'columns:s' => \$ord); 

if (defined($ord))
{
    @order = split (/\,/, $ord);
}

while (<>) 
{
    if (length($_) != 0)
    {
        Local::MusicLibrary::Filter::push_str($_, \@table, \%col_width, $filter_type, $filter_name);
    }
}

if( scalar(@table) != 0)
{
    if(defined($sort_name))
    {
        Local::MusicLibrary::Sort::sort_table(\@table, $sort_name);
    }
    Local::PrintTable::print_table(\@table, \%col_width, \@order);
}



1;
