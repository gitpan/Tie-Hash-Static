BEGIN { $| = 1; print "1..3\n" }
END { print "not ok 1\n" unless defined $loaded && $loaded }

use Tie::Hash::Static;
$loaded = 1;
print "ok 1\n";

*hash = new Tie::Hash::Static([ qw(x y z) ]);
%hash = ( 'x' => 24, 'y' => 25, 'z' => 26, 'foo' => 'bar' );

%hash = ();

print "not " unless scalar keys %hash == 3 && !exists $hash{'foo'} &&
	exists $hash{'x'} && $hash{'x'} == 24 && exists $hash{'y'} &&
	$hash{'y'} == 25 && exists $hash{'z'} && $hash{'z'} == 26;
print "ok 2\n";

*hash = new Tie::Hash::Static([ qw(x y z) ],
	{ 'x' => 22, 'y' => 23, 'z' => 24, 'foo' => 'bar' });

%hash = ();
print "not " unless scalar keys %hash == 3 && !exists $hash{'foo'} &&
        exists $hash{'x'} && $hash{'x'} == 22 && exists $hash{'y'} &&
        $hash{'y'} == 23 && exists $hash{'z'} && $hash{'z'} == 24;
print "ok 3\n";