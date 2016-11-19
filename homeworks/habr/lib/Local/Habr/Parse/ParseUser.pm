package Local::Habr::Parse::ParseUser;

use strict;
use warnings;
use Mouse;
use Mojo::DOM;
use LWP::UserAgent;

has name =>
(
    is => 'rw',
);

has karma =>
(
    is => 'rw',
);

has rating =>
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
    my $url = "https://habrahabr.ru/users/$id/"; 
    my $dom = Mojo::DOM->new(html($url));
    
    $self->{name} = $id;

    my $collection = $dom->find(
    '.voting-wjt__counter-score.js-karma_num');
    if (@$collection)
    {
        $self->{karma} = $collection->[0]->text;
    }   
    
    $collection = $dom->find('.statistic.statistic_user-rating>div');
    if (@$collection)
    {
        $self->{rating} = $collection->[0]->text;
    }   
}

1;
