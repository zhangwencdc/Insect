#!/usr/bin/perl
use strict;
use warnings;
#Usage:conda activate biobakery

my $file=$ARGV[0];#Insect_Seq.list
#my $script="/test/Data/WGS_docker/wgsqc_docker.pl";
#my $data="/test/Data/WGS_docker/";
open(F,$file);
my $header=<F>;chomp $header;
while(1){
	my $l=<F>;
	unless($l){last;}
	chomp $l;
	my @a=split"\t",$l;
	my $n=@a;
	if($n>2){
	my $fq1=$a[1];my $fq2=$a[2];
	my $Keyname=$a[0];
     
	system "mkdir sams bowtie2 profiles consensus_markers\n";

	system " metaphlan $fq1,$fq2 --input fastq -s sams/$Keyname.sam.bz2 --bowtie2out bowtie2/$Keyname.bowtie2.bz2 -o profiles/$Keyname.profile.tsv --bowtie2db /home/zhangwen/Data/Metaphlan/ --bowtie2_exe /home/zhangwen/bin/bowtie2-2.4.4-linux-x86_64/bowtie2\n";
	system "sample2markers.py -i sams/$Keyname.sam.bz2 -o consensus_markers -n 8\n";


	}
}
close F;