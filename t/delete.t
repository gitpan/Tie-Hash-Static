BEGIN { $| = 1; print "1..3\n" }
END { print "not ok 1\n" unless defined $loaded && $loaded }

use Tie::Hash::Static;
$loaded = 1;
print "ok 1\n";

*hash = new Tie::Hash::Static([ qw(x y z) ]);
print "not " unless exists $hash{'x'} && (delete $hash{'x'} || 1) &&
	exists $hash{'x'};
print "ok 2\n";

$hash = { 'x' => 'safe' };
*hash = new Tie::Hash::Static([ qw(x y z) ], $hash);
print "not " unless exists $hash{'x'} && $hash{'x'} eq 'safe' && 
	(delete $hash{'x'} || 1) && exists $hash{'x'} &&
	$hash{'x'} eq 'safe' && exists $$hash{'x'} && $$hash{'x'} eq 'safe';
print "ok 3\n";
