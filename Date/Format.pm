# Date::Format
#
# Copyright (c) 1995 Graham Barr. All rights reserved. This program is free
# software; you can redistribute it and/or modify it under the same terms
# as Perl itself.

package Date::Format;

=head1 NAME

Date::Format - Date formating subroutines

=head1 SYNOPSIS

	use Date::Format;
	
	@lt = timelocal(time);
	
	print time2str($template, time);
	print strftime($template, @lt);
	
	print time2str($template, time, $zone);
	print strftime($template, @lt, $zone);
	
	print ctime(time);
	print ascctime(@lt);
	
	print ctime(time, $zone);
	print ascctime(@lt, $zone);

=head1 DESCRIPTION

This module provides routines to format dates into ASCII strings. They
correspond to the C library routines C<strftime> and C<ctime>.

=over 4

=item time2str(TEMPLATE, TIME [, ZONE])

C<time2str> converts C<TIME> into an ASCII string using the conversion
specification given in C<TEMPLATE>. C<ZONE> if given specifies the zone
which the output is required to be in, C<ZONE> defaults to your current zone.


=item strftime(TEMPLATE, TIME [, ZONE])

C<strftime> is similar to C<time2str> with the exception that the time is
passed as an array, such as the array returned by C<localtime>.

=item ctime(TIME [, ZONE])

C<ctime> calls C<time2str> with the given arguments using the
conversion specification C<"%a %b %e %T %Y\n">

=item asctime(TIME [, ZONE])

C<asctime> calls C<time2str> with the given arguments using the
conversion specification C<"%a %b %e %T %Y\n">

=back

Each conversion specification  is  replaced  by  appropriate
characters   as   described  in  the  following  list.   The
appropriate  characters  are  determined  by   the   LC_TIME
category of the program's locale.

	%%	PERCENT
	%a	day of the week abbr
	%A	day of the week
	%b	month abbr
	%B 	month
	%c 	ctime format: Sat Nov 19 21:05:57 1994
	%d 	numeric day of the month
	%e 	DD
	%D 	MM/DD/YY
	%h 	month abbr
	%H 	hour, 24 hour clock, leading 0's)
	%I 	hour, 12 hour clock, leading 0's)
	%j 	day of the year
	%k 	hour
	%l 	hour, 12 hour clock
	%m 	month number, starting with 1
	%M 	minute, leading 0's
	%n 	NEWLINE
	%o	ornate day of month -- "1st", "2nd", "25th", etc.
	%p 	AM or PM 
	%r 	time format: 09:05:57 PM
	%R 	time format: 21:05
	%s	seconds since the Epoch, UCT
	%S 	seconds, leading 0's
	%t 	TAB
	%T 	time format: 21:05:57
	%U 	week number, Sunday as first day of week
	%w 	day of the week, numerically, Sunday == 0
	%W 	week number, Monday as first day of week
	%x 	date format: 11/19/94
	%X 	time format: 21:05:57
	%y	year (2 digits)
	%Y	year (4 digits)
	%Z 	timezone in ascii. eg: PST

=head1 AUTHOR

Graham Barr <Graham.Barr@tiuk.ti.com>

=head1 REVISION

$Revision: 2.2 $

=head1 COPYRIGHT

Copyright (c) 1995 Graham Barr. All rights reserved. This program is free
software; you can redistribute it and/or modify it under the same terms
as Perl itself.

=cut

use Time::Zone;
use Time::Local;

use strict;
no strict qw(refs);

use vars qw(@DoW @MoY @DoWs @MoYs @AMPM @Dsuf %locale);
use vars qw($sec $min $hour $mday $mon $year $wday $yday $isdst $tzname $epoch);
use vars qw(@EXPORT @ISA $VERSION);

$VERSION = sprintf("%d.%02d", q$Revision: 2.2 $ =~ /(\d+)\.(\d+)/);

require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(time2str strftime ctime asctime);

BEGIN {

 @DoW = qw(Sunday Monday Tuesday Wednesday Thursday Friday Saturday);

 @MoY = qw(January February March April May June
	   July August September October November December);

 @DoWs = map { substr($_,0,3) } @DoW;
 @MoYs = map { substr($_,0,3) } @MoY;
 
 @AMPM = qw(AM PM);

 @Dsuf = (qw(th st nd rd th th th th th th)) x 3;
 @Dsuf[11,12,13] = qw(th th th);

 %locale = (	'x' => "%m/%d/%y",
		'C' => "%a %b %e %T %Z %Y",
		'X' => "%H:%M:%S",
	     );

 my @locale;
 my $locale = "/usr/share/lib/locale/LC_TIME/default";
 local *LOCALE;

 if(open(LOCALE,"$locale")) {
  chop(@locale = <LOCALE>);
  close(LOCALE);

  @MoYs = @locale[0 .. 11];
  @MoY  = @locale[12 .. 23];
  @DoWs = @locale[24 .. 30];
  @DoW  = @locale[31 .. 37];
  @locale{"X","x","C"} =  @locale[38 .. 40];
  @AMPM = @locale[41 .. 42];
 }
}

#
# Taken from Time::ParseDate by David Muir Sharnoff <muir@idiom.com>
#

sub wkyr {
    my($wstart, $wday, $yday) = @_;
    $wday = ($wday + 7 - $wstart) % 7;
    return int(($yday - $wday + 13) / 7 - 1);
}

sub a { $DoWs[$wday] }
sub A { $DoW[$wday] }
sub b { $MoYs[$mon] }
sub B { $MoY[$mon] }
sub d { sprintf("%02d",$mday) }
sub e { sprintf("%2d",$mday) }
sub H { sprintf("%02d",$hour) }
sub h { $MoYs[$mon] }
sub I { sprintf("%02d",$hour % 12 || 12)}
sub j { sprintf("%03d",$yday + 1) }
sub k { sprintf("%2d",$hour) }
sub l { sprintf("%2d",$hour % 12 || 12)}
sub m { sprintf("%02d",$mon + 1) }
sub M { sprintf("%02d",$min) }
sub p { $hour >= 12 ?  $AMPM[1] : $AMPM[0] }
sub s { sprintf("%d",$epoch) }
sub S { sprintf("%02d",$sec) }
sub U { wkyr(0, $wday, $yday) }
sub w { $wday }
sub W { wkyr(1, $wday, $yday) }
sub y { sprintf("%02d",$year % 100) }
sub Y { sprintf("%04d",$year + 1900) }
sub Z { defined $tzname ? $tzname : uc tz_name(undef, $isdst); }

sub c { &x . " " . &X }
sub D { &m . "/" . &d . "/" . &y  }      
sub r { &I . ":" . &M . ":" . &S . " " . &p  }   
sub R { &H . ":" . &M }
sub T { &H . ":" . &M . ":" . &S }
sub t { "\t" }
sub n { "\n" }

sub o { sprintf("%2d%s",$mday,$Dsuf[$mday]) }

sub locale_fmt
{
 my $ch = shift;
 my $fmt = $locale{$ch};

 $fmt =~ s#%([%a-zA-Z])#expand($1)#sge;

 $fmt;
}

sub x { locale_fmt('x'); }
sub X { locale_fmt('X'); }
sub C { locale_fmt('C'); }


sub expand { defined &{$_[0]} ? &{$_[0]} : $_[0]; }

sub time2str ($;$$)
{
 my($fmt,$time);

 ($fmt,$time,$tzname) = @_;

 $epoch = $time;

 if(defined $tzname)
  {
   $tzname = uc $tzname;

   $tzname = sprintf("%+05d",$tzname)
	unless($tzname =~ /\D/);

   $time += tz_offset($tzname);

   ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = gmtime($time);
  }
 else
  {
   ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime($time);
  }

 $fmt =~ s#%([%a-zA-Z])#expand($1)#sge;

 $fmt;
}

sub strftime ($\@;$)
{
 my($fmt,$time);

 ($fmt,$time,$tzname) = @_;

 $epoch = $time;

 ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = @$time;

 if(defined $tzname)
  {
   $tzname = uc $tzname;

   $tzname = sprintf("%+05d",$tzname)
	unless($tzname =~ /\D/);

   my $time = timegm($sec,$min,$hour,$mday,$mon,$year) +
			tz_offset($tzname) - tz_offset();

   ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = gmtime($time);
  }

 $fmt =~ s#%([%a-zA-Z])#expand($1)#sge;

 $fmt;
}

sub ctime ($;$)
{
 my($t,$tz) = @_;
 time2str("%a %b %e %T %Y\n", $t, $tz); 
}

sub asctime (\@;$)
{
 my($t,$tz) = @_;
 strftime("%a %b %e %T %Y\n", @$t, $tz); 
}


1;

