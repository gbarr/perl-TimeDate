##
## Hungarian tables
##
## Contributed by Konrad Lorinczi (webmaster33@bigfoot.com)
##

package Date::Language::Hungarian;

use Date::Language ();
use vars qw(@ISA @DoW @DoWs @MoY @MoYs @AMPM @Dsuf %MoY %DoW $VERSION);
@ISA = qw(Date::Language);
$VERSION = "1.00";

@DoW = qw(Vasárnap Hétfõ Kedd Szerda Csütörtök Péntek Szombat);
@MoY = qw(Január Február Március Április Május Június 
	  Július Augusztus Szeptember Október November December);
@DoWs = qw(Va Hé Ke Sze Cs Pé Szo);
@MoYs = qw(Jan Feb Márc Ápr Máj Jún Júl Aug Szept Okt Nov Dec);
@AMPM = qw(DE. DU.);

@Dsuf = ('.') x 31;

@MoY{@MoY}  = (0 .. scalar(@MoY));
@MoY{@MoYs} = (0 .. scalar(@MoYs));
@DoW{@DoW}  = (0 .. scalar(@DoW));
@DoW{@DoWs} = (0 .. scalar(@DoWs));

# Formatting routines

sub format_a { $DoWs[$_[0]->[6]] }
sub format_A { $DoW[$_[0]->[6]] }
sub format_b { $MoYs[$_[0]->[4]] }
sub format_B { $MoY[$_[0]->[4]] }
sub format_h { $MoYs[$_[0]->[4]] }
sub format_p { $_[0]->[2] >= 12 ?  $AMPM[1] : $AMPM[0] }
sub format_P { lc($_[0]->[2] >= 12 ?  $AMPM[1] : $AMPM[0]) }

sub format_d { $_[0]->[3] }
sub format_m { $_[0]->[4] + 1 }
sub format_o { $_[0]->[3] . '.' }

1;
