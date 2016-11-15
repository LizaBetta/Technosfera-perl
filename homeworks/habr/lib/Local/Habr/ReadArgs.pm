package Local::Habr::ReadArgs;

use strict;
use warnings;
use diagnostics;
use 5.010;

use FindBin '$Bin';
use lib "$Bin/../..";

use Getopt::Long;

sub read_args
{
    my %arg;
    Getopt::Long::GetOptions ('name:s' => \$arg{user_name}, 
                          'post:i' => \$arg{post_id},
                          'id:i' => \$arg{post_id},
                          'n:i' => \$arg{des_posts},
                          'format:s' => \$arg{format},
                          'refresh' => \$arg{refresh},
                          'self_commenters' => \$arg{self_commenters},
                          '<>' => \&arg_type);   
    if (defined(my $a = arg_type()))
    {
        $arg{$a} = 1;
    }
    return %arg;
}

sub arg_type
{
    state $arg = shift;
    return $arg;
}

1;
