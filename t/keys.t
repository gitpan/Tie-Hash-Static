BEGIN { $| = 1; print "1..5\n" }
END { print "not ok 1\n" unless defined $loaded && $loaded }

use Tie::Hash::Static;
$loaded = 1;
print "ok 1\n";

*hash = new Tie::Hash::Static([ qw(x y z) ]);

print "not " unless scalar keys %hash == 3 && scalar keys %hash == 3;
print "ok 2\n";

@keys = sort keys %hash;
print "not " unless $keys[0] eq 'x' && $keys[1] eq 'y' && $keys[2] eq 'z';
print "ok 3\n";

$values = { 'x' => '13', 'y' => 'foo', 'z' => 'what' };
*hash = new Tie::Hash::Static([ qw(x y z) ], $values);
$failed = 0;

while(($key, $value) = each %hash) {
    $failed++ unless exists $hash{$key} && $hash{$key} eq $value &&
	exists $$values{$key} && $$values{$key} eq $value;
}
print "not " if $failed;
print "ok 4\n";

while(($key, $value) = each %hash) {   # multiple times is a toughie
    $failed++ unless exists $hash{$key} && $hash{$key} eq $value &&
        exists $$values{$key} && $$values{$key} eq $value;
}
print "not " if $failed;
print "ok 5\n";
