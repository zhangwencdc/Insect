#!/usr/bin/perl
use strict;
use warnings;

my $file=$ARGV[0];
my $out=$ARGV[1];

open(F,$file);
open(OUT,">$out");
my $l=<F>;chomp $l;print OUT "$l\n";
while(1){
	my $l=<F>;
	unless($l){last;}
	chomp $l;
	my @a=split"\\|",$l;
#	print "$a[3]\n";
	if($a[3]=~/AMPLICON/){next;}
	unless($a[3]=~/WGS/ || $a[3]=~/RNA-Seq/){next;}
	if($a[33]=~/nan/ || $a[33]=~/not applicable/){next;}  ##34ÁÐcollection_date
	unless($a[33]=~/[0-9a-zA-Z]/){next;}
	
	if($a[34]=~/nan/ || $a[34]=~/not applicable/){next;}  ##35ÁÐgeo_loc_name
	unless($a[34]=~/[0-9a-zA-Z]/){next;}

	print OUT "$l\n";
	print "$a[0]\n";
}
close F;
close OUT;