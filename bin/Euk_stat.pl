#!/usr/bin/perl
use strict;
#use warnings;
use File::Basename qw(basename dirname);
#Usage: 合并bowtie report结果
#剔除昆虫宿主后，查找其他真核物种
#perl Euk_stat.pl /home/zhangwen/project/2024Insect/Analysis/03.Target/Host 50 Euk.cat
my @file=glob "$ARGV[0]/*.report"; 
my $cutoff=$ARGV[1];# cutoff 5 指align 5%
open(O,">$ARGV[2]");
print O "Sample,Target,Target Length,Match Read Num,Align Length,Coverage%,Depth,Annotation\n";
my %filter;
$filter{"Andiperla"}++;
$filter{"Apis"}++;
$filter{"Aquatica"}++;
$filter{"Bactrocera"}++;
$filter{"Bathycoelia"}++;
$filter{"Bombus"}++;
$filter{"Bombyx"}++;
$filter{"Cnaphalocrocis"}++;
$filter{"Collembola"}++;
$filter{"Cortaritermes"}++;
$filter{"Ctenocephalides"}++;
$filter{"Dactylopius"}++;
$filter{"Diaphanes"}++;
$filter{"Diaphorina"}++;
$filter{"Drosophila"}++;
$filter{"Glossina"}++;
$filter{"Haematopinus"}++;
$filter{"Harmonia"}++;
$filter{"Monochamus"}++;
$filter{"Nasutitermes"}++;
$filter{"Nauphoeta"}++;
$filter{"Odontotaenius"}++;
$filter{"Pachnoda"}++;
$filter{"Parastrachia"}++;
$filter{"Periplaneta"}++;
$filter{"Spodoptera"}++;
$filter{"Tenebrio"}++;
$filter{"Thaumetopoea"}++;
$filter{"Tineola"}++;


my %genus;
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
		unless($b[0]>=$cutoff){next;}
		
		my @c=split">",$l;
		my $anno=pop @c;
		my @d=split" ",$anno;
		my $genus=$d[1];
		if(exists $filter{$genus}){next;}
		$genus{$d[1]}++;print O "$fname,$l\n";
	}
	close F;
}
close O;
my @genus=sort keys %genus;
print "Genus,Positive sample num\n";
foreach my  $g(@genus) {
	print "$g,$genus{$g}\n";
}