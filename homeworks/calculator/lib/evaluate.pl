=head1 DESCRIPTION

Эта функция должна принять на вход ссылку на массив, который представляет из себя обратную польскую нотацию,
а на выходе вернуть вычисленное выражение

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


sub evaluate {
	my $rpn = shift;
	my @bin_op = ('+', '-', '*', '/', '^');
	my @stack;

	foreach my $c (@$rpn)
	{
		if ($c ~~ @bin_op)
		{
			my $b = pop(@stack);
			my $a = pop(@stack);
			if($c eq '+')
			{
				push(@stack, $a + $b);	
			}
			if($c eq '-')
			{
				push(@stack, $a - $b);	
			}
			if($c eq '*')
			{
				push(@stack, $a * $b);	
			}
			if($c eq '/')
			{
				push(@stack, $a / $b);	
			}
			if($c eq '^')
			{
				push(@stack, $a ** $b);	
			}
		}
		elsif ($c eq 'U-')
		{
			my $a = pop(@stack);
			push(@stack, -$a);	
		}
		elsif($c ne 'U+')
		{
			push(@stack, 0 + $c);
		}
	}

	return $stack[0];
}

1;
