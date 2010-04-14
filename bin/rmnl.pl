#!/usr/bin/perl
# remove newlines, replace with commas
while (<>) { chomp; printf("%s, ", $_); }
