BEGIN { $| = 1; print "1..3\n" }
END { print "not ok 1\n" unless defined $loaded && $loaded }

use Tie::Hash::Static;
$loaded = 1;
print "ok 1\n";

*hash = new Tie::Hash::Static([ qw(x y z) ]);
%hash = ('x' => 24, 'y' => 25, 'z' => 26, 'foo' => 'whatever');

print "not " unless $hash{'x'} == 24 && $hash{'y'} == 25 && $hash{'z'} == 26 &&
                    !$hash{'foo'};
print "ok 2\n";

*hash = new Tie::Hash::Static([ qw(x y z) ], { 'x' => 21, 'y' => 22, 'z' => 23,
					       'foo' => 'whatever' });

print "not " unless $hash{'x'} == 21 && $hash{'y'} == 22 && $hash{'z'} == 23 &&
                    !$hash{'foo'};
print "ok 3\n";
