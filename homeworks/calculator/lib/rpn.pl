=head1 DESCRIPTION

Эта функция должна принять на вход арифметическое выражение,
а на выходе дать ссылку на массив, содержащий обратную польскую нотацию
Один элемент массива - это число или арифметическая операция
В случае ошибки функция должна вызывать die с сообщением об ошибке

=cut

use 5.010;
use strict;
use warnings;
use diagnostics;
BEGIN{
	if ($] < 5.018) {
		package experimental;
		use warnings::register;
	}
}
no warnings 'experimental';
use FindBin;
require "$FindBin::Bin/../lib/tokenize.pl";

sub priority
{
	my $c = shift;
	if(($c eq "U-") || ($c eq "U+"))
	{
		return 4;
	}
	elsif (($c eq '+') || ($c eq '-'))
	{
		return 1;
	}
	elsif (($c eq "*") || ($c eq /"\"/))
	{
		return 2;
	}
	elsif ($c eq "^")
	{
		return 3;
	}
	elsif (($c eq "(") || ($c eq ")"))
	{
		return 0;
	}
}

sub right_assoc
{
	my $c = shift;
	if(($c eq '^') || ($c eq 'U-') || ($c eq 'U+'))
	{	
		return 1;
	}
	else
	{
		return 0;
	}	
}

sub rpn 
{
	my $expr = shift;
	my $source = tokenize($expr);
	my @res;
	my @stack;
	for my $c (@$source)
	{
		given($c)
		{
			when (/^\s*$/){}
			when (/\d/)
			{
				push (@res, $c);			
			}
			when(['+','-','*', '/', '^', 'U+', 'U-'])
			{
				my $el;
				while(@stack != 0)
				{
					$el = pop(@stack);
					if(right_assoc($c))
					{
						if(priority($c) < priority($el))
						{
							push(@res, $el);
						}
						else
						{
							push(@stack, $el);
							last;
						}
					}
					else
					{
						if(priority($c) <= priority($el))
						{
							push(@res, $el);
						}
						else
						{
							push(@stack, $el);
							last;
						}
					}
				}
				push(@stack, $c);
			}
			when(['('])
			{
				push(@stack, $c);
			}
			when([')'])
			{
				my $el;
				while(@stack != 0)
				{
					$el = pop(@stack);
					if($el ne '(')
					{
						push(@res, $el);
					}
					else
					{
						last;
					}
				}
				if($el ne '(')
				{
					die "error, ')'";
				}
			}
			default
			{
				die "error, Bad: '$_'";
			}
		}
	}
	foreach (0..$#stack)
	{
		my $c = pop(@stack);
		my @operators = ('+', '-', '*', '/', '^', 'U+', 'U-');
		if($c ~~ @operators)
		{
			push(@res, $c);
		}
		else
		{
			die "error, Bad: '$_'";
		}
	}
	return \@res;
}

1;


