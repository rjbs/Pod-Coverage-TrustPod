#!perl
use strict;
use warnings;

use Test::More 'no_plan';

my $PC = 'Pod::Coverage::TrustPod';
require_ok($PC);

{
  local @INC = './t/eg';
  {
    my $obj = $PC->new(
      package  => 'NoCoverage',
    );

    if (! defined $obj->coverage) {
      diag "no coverage: " . $obj->why_unrated;
      die;
    }

    is($obj->coverage, 0, "no coverage in NoCoverage");
    is_deeply([ $obj->naked ], [ qw(not_covered) ], "1 symbol");
  }

  {
    my $obj = $PC->new(
      package  => 'PodPrivate',
    );

    is($obj->coverage, 1, 'total coverage in PodPrivate');
  }

  {
    my $obj = $PC->new(
      package  => 'PodFor',
    );

    is($obj->coverage, 1, 'total coverage in PodFor');
  }
}
