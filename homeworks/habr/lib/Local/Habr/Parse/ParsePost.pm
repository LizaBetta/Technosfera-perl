package Local::Habr::Parse::ParsePost;

use strict;
use warnings;
use Mouse;
use LWP::UserAgent;
use Mojo::DOM;

has id =>
(
    is => 'rw'
);

has author =>
(
    is => 'rw',
);

has theme =>
(
    is => 'rw',
);

has rating =>
(
    is => 'rw',
);

has views =>
(
    is => 'rw',
);

has stars =>
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
    $self->{id} = $id;
    my $collection = $dom->find('.post-type_nowrap>a');
    if (!(defined($collection->[0])))
    {
        $collection = $dom->find('.author-info__username>a');
    }
    my $i = $#$collection;
    if (@$collection)
    {
        $self->{author} = $collection->[$i]->text;
        $self->{author} =~ /@(.*)/;
        $self->{author} = $1;
    }
    
    $collection = $dom->find('.post__title>span');
    if ($#$collection)
    {
        $self->{theme} = $collection->[1]->text; 
    }
    
    $collection = $dom->find('.views-count_post');
    if (@$collection)
    {
        $self->{views} = $collection->[0]->text; 
    }

    $collection = $dom->find(  
            '.user-rating__value');
    if (@$collection)
    {
        $self->{rating} = $collection->[0]->text; 
    }

    $collection = $dom->find(
            '.favorite-wjt__counter.js-favs_count');
    if (@$collection)
    {
       $self->{stars} = $collection->[0]->text; 
    }
}

1;
