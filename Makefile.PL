# This -*- perl -*- script makes the Makefile

BEGIN { require 5.002 }

use ExtUtils::MakeMaker;

$DISTNAME = 'TimeDate';
$VERSION = "1.05";
$RELTYPE  = "";

WriteMakefile(
	      NAME	=> $DISTNAME,
	      VERSION	=> $VERSION . $RELTYPE,
	      DISTNAME	=> $DISTNAME,
	      PMLIBDIRS	=> [q[Date], q[Time]],
	      clean	=> { FILES => '*% *.html *.bak *.old lib/*% lib/*/*%' },
	      dist	=> { DIST_DEFAULT	=>'all tardist',
			     COMPRESS		=>'gzip -9f',
			     SUFFIX		=>'gz'
			   },
	      linkext => { LINKTYPE=>q[] }
	     );

sub MY::libscan
{
 my($self,$path) = @_;

 return '' 
	if($path =~ m:/(RCS|CVS|SCCS)/: ||
	   $path =~ m:[~%]$: ||
	   $path =~ m:\.(orig|rej)$:
	  );
 
 $path;
}

