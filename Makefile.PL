# This -*- perl -*- script makes the Makefile

BEGIN { require 5.004 }

use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
  NAME    => 'TimeDate',
  AUTHOR  => 'Graham Barr <gbarr@pobox.com>',
  VERSION => '1.20',
  (eval { ExtUtils::MakeMaker->VERSION(6.21) } ? (LICENSE => 'perl') : ()),
  ( eval { ExtUtils::MakeMaker->VERSION(6.46) } ? (
      META_MERGE => {
        resources => {    ##
          repository => 'http://github.com/gbarr/perl-TimeDate',
        },
      }
      )
    : ()
  ),
);
