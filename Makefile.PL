
use strict;
use warnings;

use inc::Module::Install;

name          ('Pod-Coverage-TrustPod');
author        ('Ricardo Signes <rjbs@cpan.org>');
license       ('perl');
all_from      ('lib/Pod/Coverage/TrustPod.pm');

requires('Pod::Coverage' => 0.000); # minimum unknown

WriteAll();
