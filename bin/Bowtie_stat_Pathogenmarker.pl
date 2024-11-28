#!/usr/bin/perl
use strict;
#use warnings;
use File::Basename qw(basename dirname);
#Usage: 合并bowtie report结果
#perl Bowtie_stat.pl /home/zhangwen/project/2024Water/Analysis/Euk 5 Euk.cat
my @file=glob "$ARGV[0]/*.report"; 
my $cutoff=$ARGV[1];# cutoff 5 指align 5%
open(O,">$ARGV[2]");
print O "Sample,Target,Target Length,Match Read Num,Align Length,Coverage%,Depth,Annotation\n";
my %genus;my %gene;my %sample;my %s2;
foreach my $file (@file) {
	my $fname=basename($file);
	open(F,$file);my %g;
	while(1){
		my $l=<F>;
		unless ($l) {last;
		}
		chomp $l;
		my @a=split",",$l;
		my @b=split " ",$a[4];
		unless($b[0]>=$cutoff ){next;}
		print O "$fname,$l\n";
		my @c=split".fna",$a[0];
		
		my $species=substr($c[1],1);
		$gene{$a[0]}++;$g{$species}++;
	}
	close F;
	my @s=keys %g;
	foreach my $s (@s) {
		if($g{$s}>=3){
		$genus{$s}++;
		$sample{$fname}++;
		if(exists $s2{$fname}){$s2{$fname}=$s2{$fname}.",".$s;}else{$s2{$fname}=$s;}
		}
	}
	
}
close O;
my @genus=sort keys %genus;
print "Genus,Positive sample num\n";
foreach my  $g(@genus) {
	print "$g,$genus{$g}\n";
}

my @gene=sort keys %gene;

print "Gene,Positive sample num\n";
foreach my  $g(@gene) {
	print "$g,$gene{$g}\n";
}

my @sample=keys %sample;
print "Sample,Pathogen species num\n";
foreach my $sample (@sample) {
	print "$sample,$sample{$sample},$s2{$sample}\n";
}