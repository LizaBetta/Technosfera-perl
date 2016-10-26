use strict;
use warnings;
use FindBin '$Bin';
use lib "$Bin/lib";
 
use Local::Reducer::Sum;
use Local::Source::Array;
use Local::Row::JSON;

my $sum_reducer = Local::Reducer::Sum->new(
    field => 'price',
    source => Local::Source::Array->new(array => [
         '{"price": 1}',
         '{"price": 2}',
         '{"price": 3}',
     ]),
     row_class => 'Local::Row::JSON',
     initial_value => 0,
);
 
my $sum_result;
 
$sum_result = $sum_reducer->reduce_n(1);
 
$sum_result = $sum_reducer->reduce_all();

