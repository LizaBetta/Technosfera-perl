package Local::Habr::Parse::ParseAuthor;

use strict;
use warnings;
use Mouse;

use FindBin '$Bin';
use lib "$Bin/../../..";

use Local::Habr::Parse::ParseUser;

has author_of =>
(
    is => 'rw',
);

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
    $self->{author_of} = 0 + $id;
    my $url = "https://habrahabr.ru/post/$id/"; 
    my $dom = Mojo::DOM->new(html($url));
    
    my $collection = $dom->find('.post-type_nowrap>a');
    if (!(defined($collection->[0])))
    {
        $collection = $dom->find('.author-info__username>a');
    }
    my $i = $#$collection;
    if ($#$collection >= 0)
    {
        $self->{name} = $collection->[$i]->text;
        $self->{name} =~ /@(.*)/;
        $self->{name} = $1;
    }
    
    my $user = Local::Habr::Parse::ParseUser->new;
    $user->parse($self->{name});
    $self->{karma} = $user->{karma};
    $self->{rating} = $user->{rating};
}
1;
