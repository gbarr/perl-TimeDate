# This -*- perl -*- script makes the Makefile
# $Id: Makefile.PL,v 1.2 1997/01/15 21:48:56 gbarr Exp $

#--- Distribution section ---


$DISTNAME = 'TimeDate';
$VERSION  = "1.08";

BEGIN { require 5.002 }

use ExtUtils::MakeMaker;

#--- MY package

sub MY::libscan
{
 my($self,$path) = @_;

 return '' 
	if($path =~ m:/(RCS|CVS|SCCS)/: ||
	   $path =~ m:[~%]$: ||
	   $path =~ m:\.(orig|rej|nfs|b[ac]k)$:
	  );
 
 $path;
}

#--- Write the Makefile

my @clean = qw(*% *.html *.b[ac]k *.old);

push @clean, map { "*/$_" } @clean;

WriteMakefile(
	VERSION   => $VERSION,
#	DISTNAME  => $DISTNAME,
	NAME      => $DISTNAME,
	PMLIBDIRS => [qw(Date Time)],
 
	'dist'    => {COMPRESS => 'gzip -9f',
		      SUFFIX   => '.gz', 
		      DIST_DEFAULT => 'all tardist',
		     },
 
	'clean'   => {FILES => join(" ", @clean)},
);

