BEGIN { $| = 1; print "1..4\n" }
END { print "not ok 1\n" unless defined $loaded && $loaded }

use Tie::Hash::Static;
$loaded = 1;
print "ok 1\n";

*hash = new Tie::Hash::Static([ qw(x y z) ]);
$hash{'x'} = 'foo';
$hash{'y'} = 'bar';
$hash{'z'} = 'baz';
$hash{'foo'} = 'vix';

print "not " unless $hash{'x'} eq 'foo' && $hash{'y'} eq 'bar' &&
	$hash{'z'} eq 'baz' && $hash{'foo'} ne 'vix' && !$hash{'foo'};
print "ok 2\n";

$hash = { 'y' => 'fun', 'foo' => 'fix' };
*hash = new Tie::Hash::Static([ qw(x y z) ], $hash);
$hash{'x'} = {};
$hash{'y'} = 10;
#print "not " unless ref $hash{'x'} eq "HASH";  # This doesn't work in 5.003
print "not " unless defined $hash{'x'} && $hash{'y'} == 10 && !$hash{'z'} &&
	           !$hash{'foo'};
print "ok 3\n";

delete $$hash{'y'};
print "not " unless defined $hash{'y'} && $hash{'y'} == 10;
print "ok 4\n";