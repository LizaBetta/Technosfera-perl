package Local::JSONParser;

use strict;
use diagnostics;
use warnings;
use base qw(Exporter);

our @EXPORT_OK = qw( parse_json );
our @EXPORT = qw( parse_json );


sub parse_json 
{
	my $source = \$_[0];
	my $res ;
    foreach ($$source)
    {
        if (m{\G\s*(-?\d*\.?\d+)}gc or
             /\G\s*(-?\d*\.?\d+e\+\d+\s*)/gc)
        {
            return $1;
        }
        elsif (/\G\s*\"([^"\\]*)/gc)
        {
            $res = $1;
            while(!(/\G"/gc))
            {
                if (/\G\\([nt])/gc)
                {
                    if ($1 eq 'n')
                    {
                       $res = $res."\n";
                    }
                    else
                    {
                       $res = $res."\t";
                    }
                }
                elsif(/\G\\"/gc)
                {
                    $res = $res.'"';
                }
                elsif(/\G\\u(\d+)/gc)
                {
                    my $tmp = chr(hex $1);
                    #$res = $res."\x\{"."$1"."\}" ;
                    $res = $res.$tmp;
                }
                elsif (/\G\\/gc)
                {
                    die "err";
                }
                else
                {
                    /\G([^"\\]*)/gc;
                    $res = $res.$1;
                }
            }
            return $res;
        }
        elsif(/\G\s*\[/gc)
        {
            my $i = 0;
            my @res;
            while (!(/\G\s*\]/gc))
            {
                $res[$i] = parse_json($$source);
                $i++;
                /\G\s*,/gc;
            }
            return \@res;
        }
        elsif (/\G\s*\{/gc)
        {
            my %res;
            while(!(/\G\s*\}/gc))
            {
                if (/\G\s*\"([^"]*)\"\s*:/gc)
                {
                    my $key = $1;
                    $res{$key} = parse_json($$source);
                    /\G\s*,/gc;
                }
                else
                {
                    die "err";
                }
            }
            return \%res;
        }
        else
        {
            die "err";
        }
    }
}

1;
