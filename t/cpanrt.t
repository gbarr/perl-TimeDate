use Date::Format qw(time2str);
use Date::Parse qw(strptime);

print "1..4\n";

my $i = 1;

{    # RT#45067 Date::Format with %z gives wrong results for half-hour timezones

  foreach my $zone (qw(-0430 -0445)) {
    my $zone_str = time2str("%Z %z", time, $zone);
    print "# $zone => $zone_str\n";
    print "not " unless $zone_str eq "$zone $zone";
    print "ok ", $i++, "\n";
  }
}


{    # RT#48164: Date::Parse unable to set seconds correctly

  foreach my $str ("2008.11.30 22:35 CET", "2008-11-30 22:35 CET") {
    my @t = strptime($str);
    my $t = join ":", map { defined($_) ? $_ : "-" } @t;
    print "# $str => $t\n";
    print "not " unless $t eq "-:35:22:30:10:108:3600";
    print "ok ", $i++, "\n";
  }
}

