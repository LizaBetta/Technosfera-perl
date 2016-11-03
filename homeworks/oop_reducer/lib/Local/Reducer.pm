package Local::Reducer;

use strict;
use warnings;
use diagnostics;
use Mouse;

 
=encoding utf8;

=head1 NAME

Local::Reducer - base abstract reducer

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

has reduced =>
(
	is => 'rw',
    default => 0,
);

has source =>
(
    is => 'rw',
);

has row_class =>
(
    is => 'rw',   
);

has initial_value =>
(
    is => 'rw',
);

sub reduced
{
    my $self = shift;
    return $self->{'reduced'};
}

sub reduce_n
{
     my ($self, $n) = @_;
     foreach (1..$n)
     {
         $self->_reduce_one;
     }
     return $self->{'reduced'};
}
 
sub reduce_all
{
    my ($self) = @_;
    while ($self->_reduce_one)
    {}
    return $self->{'reduced'};
}

1;
