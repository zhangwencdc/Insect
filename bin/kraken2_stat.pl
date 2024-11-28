#!/usr/bin/perl
use strict;
#use warnings;
use Getopt::Long;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname); 


my $file=$ARGV[0];

my $out=$ARGV[1];


my @file=glob "$file/*.report";  ###¶ÁÈëkraken½á¹û
my %name;my %perg; my %pers;my %level; my %species;my %genus;my %sample;my %total;my %phylum;my %perp;
foreach my $file (@file) {
	my $name=basename ($file);
	$name=substr($name,0,length($name)-7);
	$name=~s/^\s+//g;
	$sample{$name}++;
	open(F,$file);
	while(1){
		my $line=<F>;
		unless($line){last;}
		chomp $line;
		my @a=split"\t",$line;
		$level{$a[4]}=$a[3];
		$a[5]=~s/^\s+//g;$a[0]=~s/^\s+//g;
		$name{$a[4]}=$a[5];
		if($a[4] eq "0" || $a[4] eq "1"){$total{$name}+=$a[1];}
		if($a[3] eq "S"){
			if($a[5]=~/sp./){next;}
			$species{$a[4]}++;$pers{$name}{$a[4]}=$a[1];
		}
		if($a[3] eq "G"){$genus{$a[4]}++;$perg{$name}{$a[4]}=$a[1];}
		if($a[3] eq "P"){$phylum{$a[4]}++;$perp{$name}{$a[4]}=$a[1];}
	}
	close F;
	
}
open(OUT,">$out.phylum");
my @sample=sort keys %sample;
my @phylum=sort {$phylum{$a}<=>$phylum{$b}} keys %phylum;print OUT "Phylum,";
foreach my $phylum (@phylum) {
	print OUT "$name{$phylum},";
}
print OUT "\n";
foreach my $sample (@sample) {
	print OUT "$sample,";
	foreach my $phylum (@phylum) {
		if(exists $perp{$sample}{$phylum}){
			my $v=$perp{$sample}{$phylum}/$total{$sample};
			print OUT "$v,";}else{
				print OUT "0,";
		}
	}
	print OUT "\n";
}
close OUT;

open(OUT,">$out.genus");
my @sample=sort keys %sample;
my @genus=sort {$genus{$a}<=>$genus{$b}} keys %genus;print OUT "Genus,";
foreach my $genus (@genus) {
	print OUT "$name{$genus},";
}
print OUT "\n";
foreach my $sample (@sample) {
	print OUT "$sample,";
	foreach my $genus (@genus) {
		if(exists $perg{$sample}{$genus}){
			my $v=$perg{$sample}{$genus}/$total{$sample};
			print OUT "$v,";}else{
				print OUT "0,";
		}
	}
	print OUT "\n";
}
close OUT;

open(OUT,">$out.species");
my @sample=sort keys %sample;
my @species=sort {$species{$a}<=>$species{$b}} keys %species;print OUT "Species,";
foreach my $species (@species) {
	
	print OUT "$name{$species},";
}
print OUT "\n";
foreach my $sample (@sample) {
	print OUT "$sample,";
	foreach my $species (@species) {
		#print "$sample\t$species\t$pers{$sample}{$species}\n";
		if(exists $pers{$sample}{$species}){
			my $v=$pers{$sample}{$species}/$total{$sample};
			print OUT "$v,";
		}else{print OUT "0,";
		}
	}
	print OUT "\n";
}
close OUT;