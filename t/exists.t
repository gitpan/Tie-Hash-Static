BEGIN { $| = 1; print "1..3\n" }
END { print "not ok 1\n" unless defined $loaded && $loaded }

use Tie::Hash::Static;
$loaded = 1;
print "ok 1\n";

*hash = new Tie::Hash::Static([ qw(x y z) ]);

print "not " unless exists $hash{'x'} && exists $hash{'y'} &&
	exists $hash{'z'} && !exists $hash{'foo'};
print "ok 2\n";

*hash = new Tie::Hash::Static([ qw(x y z) ], { 'y' => 10, 'foo' => 'bar' });
print "not " unless exists $hash{'x'} && exists $hash{'y'} &&
        exists $hash{'z'} && !exists $hash{'foo'};
print "ok 3\n";