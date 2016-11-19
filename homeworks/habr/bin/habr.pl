#!/usr/bin/env perl

use strict;
use warnings;
use diagnostics;

use FindBin '$Bin';
use lib "$Bin/../lib";

use Local::Habr::Parse::ParsePost;
use Local::Habr::Parse::ParseAuthor;
use Local::Habr::Parse::ParseUser;
use Local::Habr::Parse::ParseCommentors;
use Local::Habr::Base::PostsTable;
use Local::Habr::Base::PersonsTable;
use Local::Habr::Base::CommentersTable;
use Local::Habr::ReadArgs;

my $posts = Local::Habr::Base::PostsTable->new();
my $persons = Local::Habr::Base::PersonsTable->new();
my $commenters = Local::Habr::Base::CommentersTable->new();
my %arg = Local::Habr::ReadArgs::read_args;
use Data::Dumper;


sub print_data
{
    my ($format, $data) = @_;
    if ($format eq 'ddp')
    {
        print Dumper($data->fetchrow_hashref());
    }
    elsif ($format eq 'json')
    {
        use JSON;
        print (JSON->new->encode($data->fetchrow_hashref));
        print ("\n");
    }
}

sub get_data
{
    my ($table, $id, $parser, $query, $refresh) = @_; 
    my $sth = $table->dbh->
            prepare($query);
    if($sth->execute($id) == 0 or defined($refresh))
    {
        my $data = $parser->new();
        $data->parse($id);
        $table->set($data);
        $sth = $table->dbh->prepare($query);
        $sth->execute($id);
    }
    return $sth;
}

sub get_commenters
{
    my ($commenters) = @_;
    my $data = Local::Habr::Parse::ParseCommentors->new;
    $data->parse($arg{post_id});
    my $users = $data->users;
    foreach(@$users) 
    {
        my $sth = $commenters->dbh->
                prepare('SELECT nik FROM commenters WHERE nik=? and post=?');
        if($sth->execute($_, $arg{post_id}) == 0)
        {
             $commenters->set($arg{post_id}, $_);
        }
    }
}

sub get_commenters_info
{
    my ($commenters, $persons, %arg) = @_;
    my $users;
    my $sth = $commenters->dbh->
            prepare('SELECT nik FROM commenters WHERE post=?');
    if($sth->execute($arg{post_id}) == 0)
    {
        get_commenters($commenters);
        $sth->execute($arg{post_id});
    }
    my $i = 0;
    while (my @user = $sth->fetchrow_array)
    { 
        $users->[$i++] = $user[0];
    }
    return $users;
}



if ($arg{user})
{
    if (defined($arg{user_name})) 
    {
        my $data = get_data($persons, $arg{user_name}, 
                    'Local::Habr::Parse::ParseUser',
                    'SELECT nik, karma, rating FROM person WHERE nik=?',
                    $arg{refresh});
        print_data($arg{format}, $data);
    }
    elsif ($arg{post_id})
    {  
        my $data = get_data($persons, $arg{post_id}, 
                    'Local::Habr::Parse::ParseAuthor',
                    'SELECT nik, karma, rating FROM person WHERE author_of=?',
                    $arg{refresh});
        print_data($arg{format}, $data);
    }
}
elsif ($arg{post_id}) 
{ 
    my $post = get_data($posts, $arg{post_id}, 
                'Local::Habr::Parse::ParsePost',
                'SELECT * FROM post WHERE id=?',
                $arg{refresh});
    my $users = get_commenters_info($commenters, $persons, %arg);
    if (defined($arg{commenters}))
    { 
        foreach (@$users)
        {
            my $data = get_data($persons, $_, 
                'Local::Habr::Parse::ParseUser',
                'SELECT nik, karma, rating FROM person WHERE nik=?',
                $arg{refresh});
            print_data($arg{format}, $data);
        }
    }
    else
    { 
        print_data($arg{format}, $post); 
    }
}
elsif (defined($arg{des_posts}))
{
    my $sth = $commenters->dbh->prepare
        ("SELECT post FROM commenters GROUP BY post HAVING COUNT(post)<?");

    if ($sth->execute($arg{des_posts}) != 0)
    {
        while (my @post = $sth->fetchrow_array)
        {
            my $post = get_data($posts, $post[0], 
                'Local::Habr::Parse::ParsePost',
                'SELECT * FROM post WHERE id=?',
                $arg{refresh});
            print_data($arg{format}, $post);
        }
    }
}
elsif (defined($arg{self_commenters}))
{
    my $sth = $posts->dbh->prepare(
                "SELECT post.author FROM post,commenters 
                WHERE post.author=commenters.nik and 
                post.id=commenters.post");
    if ($sth->execute() != 0)       
    {
        while (my @users = $sth->fetchrow_array)
        {
            my $data = get_data($persons, $users[0], 
                'Local::Habr::Parse::ParseUser',
                'SELECT nik, karma, rating FROM person WHERE nik=?',
                $arg{refresh});
            print_data($arg{format}, $data);
        }
    }
}


1;
