# Copyright (C) 1997 Ashley Winters <jql@accessone.com>. All rights reserved.
#
# This library is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.

package Tie::Hash::Static;

use strict;
use vars qw($VERSION);

$VERSION = '0.01';

sub new {
    my $class = shift;
    my $hash = {};

    tie(%{$hash}, $class, @_);

    return $hash;
}

sub TIEHASH {
    my $class = shift;
    my $self = bless {
		   'elements' => {},
		   'hash' => {},
		   'search' => [ 'special', 'elements' ],
		   'scan' => 0
	       }, $class;
    my $i;

    for($i = 0; $i < @{$_[0]}; $i++) {
	$$self{'elements'}{${$_[0]}[$i]} = undef;
    }
    $$self{'hash'} = $_[1] if @_ > 1 && ref $_[1] eq "HASH";

    return $self;
}

sub FETCH {
    my $self = shift;
    my $key = shift;

    if(exists $$self{'elements'}{$key}) {
	return $$self{'hash'}{$key} if exists $$self{'hash'}{$key};
	return $$self{'elements'}{$key};
    }

    return undef;
}

sub STORE {
    my $self = shift;
    my $key = shift;
    my $value = shift;

    if(exists $$self{'elements'}{$key}) {
	$$self{'hash'}{$key} = $value if exists $$self{'hash'}{$key};
	$$self{'elements'}{$key} = $value;   # keep consistent, not a bug
    }
}

sub EXISTS {
    my $self = shift;
    my $key = shift;

    return exists $$self{'elements'}{$key};
}

sub CLEAR {}            # Irrelevant
sub DELETE {}           # Equally so
sub DESTROY {}          # Might as well define it

sub FIRSTKEY {
    my $self = shift;
    $$self{'scan'} = 0;

    foreach(@{$$self{'search'}}) {
	my $key = scalar keys %{$$self{$_}} || ($$self{'scan'}++, next);
	$key = each %{$$self{$_}};
	return $key if $key;
	$$self{'scan'}++;
    }

    $$self{'scan'} = 0;
    return undef;
}

sub NEXTKEY {
    my $self = shift;

    foreach(@{$$self{'search'}}[$$self{'scan'} .. $#{$$self{'search'}}]) {
        my $key = each %{$$self{$_}};
        return $key if $key;
        $$self{'scan'}++;
	$key = scalar keys %{$$self{$$self{'search'}[$$self{'scan'}]}} if
	    $$self{'scan'} < @{$$self{'search'}};
    }

    $$self{'scan'} = 0;
    return undef;
}

1;
__END__

=head1 NAME

Tie::Hash::Static - Perl module for the creations of fixed-size tied hashes

=head1 SYNOPSIS

  use Tie::Hash::Static;

  $tiedhash = new Tie::Hash::Static(\@keys [, $hash]);

=head1 DESCRIPTION

The use of this module is relatively straight-forward. The first argument
is a list of keys to allow to be accessed from within $tiedhash, and
the optional second argument is a hash to search for whatever actions are
performed on $tiedhash.

Any access to a key not listed in @keys is guaranteed to fail. Any access
to a key that exists in $hash will cause an access to $hash, instead of
the Tie::Hash::Static object.

=head1 AUTHOR

Ashley Winters <jql@accessone.com>

=head1 SEE ALSO

perl(1), perltie(1).

=cut
