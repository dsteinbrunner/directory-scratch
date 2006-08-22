#!/usr/bin/perl
# 01-scratch.t 
# Copyright (c) 2006 Jonathan Rockway <jrockway@cpan.org>

use Test::More tests => 16;
use Directory::Scratch;

my $temp = Directory::Scratch->new;
my $base = $temp->base;

# create (4)
ok($temp);
ok(-e $base, 'tempdir exists');
ok(-d _, 'tempdir is a directory');
ok(-w _, 'tempdir is writable');

# mkdir (3)
my $dir = $temp->mkdir('foo/bar/baz');
ok($dir =~ m{foo.bar.baz.?$}, 'dir has a reasonable name');
ok(-e $dir, 'dir exists');
ok(-d $dir, 'dir is a directory');

# touch (2)
my $file = $temp->touch('foo/bar/baz/bat', qw{Here are some lines});
ok(-e $file, 'file exists');
ok(-r $file, 'file readable');

# touch with lines (2)
my $lfile = $temp->touch('baa', "This is a single line");
my @lines = Directory::Scratch::read_file($lfile);
is($lines[0], "This is a single line\n");
is($lines[1], undef);

$lfile = $temp->touch('baaa', qw{There is more than one line});
@lines = Directory::Scratch::read_file($lfile);
chomp @lines;
is_deeply(\@lines, [qw{There is more than one line}]);

ok( my $fh = $temp->openfile( 'baaa' ), "openfile()" );
ok( fileno($fh), "openfile() returned a filehandle" );

# delete (2)
$temp->delete('foo/bar/baz/bat');
ok(!-e $file, 'file went away');
$temp->delete('foo/bar/baz');
ok(!-e $dir, 'dir went away');
