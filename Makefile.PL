# This -*- perl -*- script makes the Makefile
# $Id: //depot/TimeDate/Makefile.PL#6 $

#--- Distribution section ---

$DISTNAME = 'TimeDate';
$VERSION  = "1.11";

#--- Write the Makefile

BEGIN { require 5.002 }

use ExtUtils::MakeMaker;

WriteMakefile(
	VERSION   => $VERSION,
	NAME      => $DISTNAME,
	@ppd
);


