#!/usr/bin/perl
use strict;
#use warnings;

#Usage��ͳ������������

my $file=$ARGV[0];#�����ļ����ڵ��ļ���WGS_Report/
my $cutoff=$ARGV[1];#align cutoff ��Ĭ��Ϊ70
my $out=$ARGV[2];#���ܽ��Host_stat.csv

my @file=glob "$file/*.host.csv";
open(OUT,">$out");
print OUT "Sample,Coverage,Host\n";
foreach my $f (@file) {
	open(F,$f);my $bestn="NA";my $best=0;
	while(1){
		my $l=<F>;
		unless($l){last;}
		chomp $l;
		if($l=~/Homo sapiens/){next;}
		if($l=~/Mus musculus/){next;}
		my @a=split",",$l;
		my @b=split" ",$a[4];
		unless($b[0]>=$cutoff){next;}
		if($b[0]>=$best){
			$best=$b[0];$bestn=$a[6];
		}
	}
	close F;
	my @c=split " ",$bestn;
	my $target=$c[1]." ".$c[2];
	print OUT "$f,$best,$target\n";
}
