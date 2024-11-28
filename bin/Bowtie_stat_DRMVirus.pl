#!/usr/bin/perl
use strict;
#use warnings;
use File::Basename qw(basename dirname);
#Usage: 合并bowtie report结果
#perl Bowtie_stat_DRMVirus.pl ./ 90 ../DRMVirus.stat >../DRMVirus.stat.v2
my @file=glob "$ARGV[0]/*.report"; 
my $cutoff=$ARGV[1];# cutoff 5 指align 5%
open(O,">$ARGV[2]");
print O "Sample,Target,Target Length,Match Read Num,Align Length,Coverage%,Depth,Annotation\n";
my %g;my %gene;my %anno;
foreach my $file (@file) {
	my $fname=basename($file);
	open(F,$file);
	while(1){
		my $l=<F>;
		unless ($l) {last;
		}
		chomp $l;
		my @a=split",",$l;
		my @b=split " ",$a[4];
		unless($b[0]>=$cutoff ){next;}
		print O "$fname,$l\n";
		$anno{$a[0]}=$a[6].",Length:$a[1]";
		$gene{$a[0]}++;$g{$fname}++;
	}
	close F;
	
	
}
close O;


my @gene=sort keys %gene;

print "Gene,Positive sample num\n";
foreach my  $g(@gene) {
	print "$g,$gene{$g},$anno{$g}\n";
}

my @sample=keys %g;
print "Sample,Pathogen species num\n";
foreach my $sample (@sample) {
	print "$sample,$g{$sample}\n";
}