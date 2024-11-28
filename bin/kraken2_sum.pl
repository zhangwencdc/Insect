#!/usr/bin/perl
use strict;
#use warnings;
use Getopt::Long;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname); 


my $file=$ARGV[0];
my $type=$ARGV[1];
my $out=$ARGV[2];

open(OUT,">$out");print OUT "Strain,";
my @file=glob "$file/*.report";
my %read;my %total;my %group;
foreach my $file (@file) {
	my $name=basename ($file);
	$name=substr($name,0,length($name)-7);
	$name=~s/^\s+//g;
	print OUT "$name,";
	open(F,$file);my $sum;my $top_p;my $top;
	while(1){
		my $line=<F>;
		unless($line){last;}
		chomp $line;
		my @a=split"\t",$line;
		if($a[4] eq "0"){$sum+=$a[1];}
		if($a[4] eq "1"){$sum+=$a[1];}
		unless($a[3] eq $type){next;}
		$a[5]=~s/^\s+//g;
		$read{$name}{$a[5]}=$a[1];$group{$a[5]}++;
		if($a[1]>$top_p){$top=$a[5];$top_p=$a[1];}
	}
	close F;
	$total{$name}=$sum;
	my $p=$top_p/$sum;
	print "Top,$name,$top,$p\n";
}
print OUT "\n";
my @group=keys %group;
foreach my $group (@group) {
	print OUT "$group,";my $t=1;my $gsum;my $fnum=@file;
	foreach my $file (@file) {
		my $name=basename ($file);
	$name=substr($name,0,length($name)-7);
	$name=~s/^\s+//g;
	my $s=$read{$name}{$group}/$total{$name};$gsum+=$s;
		print OUT "$s,";
		unless($s>0){$t=0;}
	}
	print OUT "\n";
	if($t==1){my $avg=$gsum/$fnum;print "Core,$group,$avg\n"};
}

