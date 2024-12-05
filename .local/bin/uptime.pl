#!/usr/bin/perl

# # typical output from command line "uptime"
# $_ = '10:22  up 9 days, 53 mins, 2 users, load averages: 1.53 1.07 0.96';
$_ = `uptime`;
s/^(.+up )(.+), \d+ users, load averages(.+)$/$2/i;
s/mins/minutes/i;
s/hrs/hours/i;
s/\b1:/1 hour, /i;
s/\b(\d+):/$1 hours, /i;
s/\b01$/1 minute/i;
s/\b0(\d{1})$/$1 minutes/i;
s/\b(\d{2})$/$1 minutes/i;
s/(\d+):(\d{2})/$1 hours, $2 minutes/i;
s/(\s+)/ /g;
print "$_\n";

