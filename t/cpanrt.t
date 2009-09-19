use Date::Format qw(time2str);

print "1..2\n";

my $i = 1;

{    # RT#45067 Date::Format with %z gives wrong results for half-hour timezones
  foreach my $zone (qw(-0430 -0445)) {
    my $zone_str = time2str("%Z %z", time, $zone);
    print "# $zone => $zone_str\n";
    print "not " unless $zone_str eq "$zone $zone";
    print "ok ", $i++, "\n";
  }
}
