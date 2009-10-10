#!perl
use strict;
use warnings;

use Test::More 'no_plan';
use Test::Exception;

use Carp::Heavy; # Preload since we mangle @INC

my $PC = 'Pod::Coverage::TrustPod';


require_ok($PC);


lives_ok { 
    local @INC = './t/eg';
    {
        my $obj = $PC->new( package  => 'ChildWithPod',);
        if (! defined $obj->coverage) {
          diag "no coverage: " . $obj->why_unrated;
          die;
        }
    }
    
} 'expecting to live';
