use strict;
use warnings;
package Pod::Coverage::TrustPod;
use base 'Pod::Coverage::CountParents';

use Pod::Eventual::Simple;

=head1 NAME

Pod::Coverage::TrustPod - allow POD to contain Pod::Coverage hints

=cut

our $VERSION = '0.002';

=head1 DESCRIPTION

This is a Pod::Coverage subclass (actually, a subclass of
Pod::Coverage::CountParents) that allows the POD itself to declare certain
symbol names trusted.

Here is a sample Perl module:

  package Foo::Bar;

  =head1 NAME

  Foo::Bar - a bar at which fooes like to drink

  =head1 METHODS

  =head2 fee

  returns the bar tab

  =cut

  sub fee { ... }

  =head2 fie

  scoffs at bar tab

  =cut

  sub fie { ... }

  sub foo { ... }

  =begin Pod::Coverage

    foo

  =end Pod::Coverage

  =cut

This file would report full coverage, because any non-empty lines inside a
block of POD targeted to Pod::Coverage are treated as C<trustme> patterns.
Leading and trailing whitespace is stripped and the remainder is treated as a
regular expression.

=cut

sub __get_pod_trust {
  my ($self) = @_;

  my $output = Pod::Eventual::Simple->read_file($self->{pod_from});

  my @hunks = grep {;
    no warnings 'uninitialized';
    (($_->{command} eq 'begin' and $_->{content} =~ /^Pod::Coverage\b/)
    ...
    ($_->{command} eq 'end' and $_->{content} =~ /^Pod::Coverage\b/))
    and
    $_->{type} eq 'verbatim'
  } @$output;

  return [
    grep { s/^\s+//; s/\s+$//; /\S/ }
    map  { split /\n/, $_->{content} } @hunks
  ];
}

sub _trustme_check {
  my ($self, $sym) = @_;

  my $from_pod = $self->{_trust_from_pod} ||= $self->__get_pod_trust;

  return grep { $sym =~ /$_/ } @{ $self->{trustme} }, @$from_pod;
}

=head1 COPYRIGHT AND AUTHOR

This distribution was written by Ricardo Signes, E<lt>rjbs@cpan.orgE<gt>.

Copyright 2008.  This is free software, released under the same terms as perl
itself.

=cut

1;
