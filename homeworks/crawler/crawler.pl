use strict;
use warnings;
use diagnostics;

use AnyEvent::HTTP;
use Web::Query;
$AnyEvent::HTTP::MAX_PER_HOST = 100;

my $host = 'https://en.wikipedia.org';

my %url_set = ();
my $cv = AE::cv;

sub parser
{
    my ($data, $url) = @_;
    $url_set{$url} = length $data;
    print "$url\n";
    
    my $a_u = Web::Query->new_from_html($data);
    my $arr_urls = $a_u->find('a')->map(sub {$_[1]->attr('href')});
    foreach(@$arr_urls)
    {
        if (keys %url_set >= 10)
        {
            return;
        }
        if (defined($_) && /^\/wiki\//)
        {
           my $ref = $host . $_;
           handling_url($ref);           
        }
    }
}

sub handling_url  
{
    my $url = shift;

    if (exists($url_set{$url}))
    {
        return;
    }
    $url_set{$url} = undef;
    $cv->begin;
    http_get    $url,
                sub
                {
                    utf8::decode($_[0]);
                    parser($_[0], $url);
                    $cv->end;    
                };
} 

handling_url($host);
#$cv->recv;


