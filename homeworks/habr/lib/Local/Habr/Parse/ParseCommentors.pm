package Local::Habr::Parse::ParseCommentors;

use strict;
use warnings;

use LWP::UserAgent;
use Mojo::DOM;
use Mouse;

use Local::Habr::Parse::ParseUser; 

has users =>
(
    is => 'rw',
);

sub html
{
    my $url = shift;
    my $ua = LWP::UserAgent->new;
    $ua->timeout(10);
    $ua->env_proxy;

    my $response = $ua->get($url);
    
    if ($response->is_success)
    {
        return $response->decoded_content;  
    }
    else
    {
        die $response->status_line;
    }
}

sub parse
{
    my ($self, $id) = @_;
    my $url = "https://habrahabr.ru/post/$id/"; 
    my $dom = Mojo::DOM->new(html($url));
    my $collection = $dom->find('.comment_body ');
    my $i = 0;
    foreach (@$collection)
    {
        my $comment = $_->find('a');
        if ($#$comment > 0)
        {
            $self->{users}[$i] = $comment->[1]->text();
            ++$i;
        }
    }
}

1;
