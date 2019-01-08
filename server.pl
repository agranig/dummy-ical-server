#!/usr/bin/perl
use strict;
use warnings;
use v5.14;

use Mojolicious::Lite;

get "/" => sub {
    my $c = shift;
    my $fh;
    my $calfile = "conf.ical";
    unless(open $fh, "<", $calfile) {
        $c->render(text => "failed to open $calfile: $!", format => "text");
    } else {
        my $data = do { local $/; <$fh> };
        $c->res->headers->content_disposition("attachment; filename=$calfile;");
        $c->render(text => $data, format => "vcal");
    }
};

app->types->type(vcal => "text/calendar");
app->secrets(["vcal test"]);
app->start;
