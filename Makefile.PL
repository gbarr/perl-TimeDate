# This -*- perl -*- script makes the Makefile
# $Id: //depot/TimeDate/Makefile.PL#3 $

#--- Distribution section ---

$DISTNAME = 'TimeDate';
$VERSION  = "1.07";

BEGIN { require 5.002 }

use ExtUtils::MakeMaker;

#--- Write the Makefile

WriteMakefile(
	VERSION   => $VERSION,
	NAME      => $DISTNAME,
);

