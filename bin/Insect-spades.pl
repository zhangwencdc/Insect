#!/usr/bin/perl
use strict;
use warnings;
use File::Basename qw(basename dirname);
#cd /test/project/2024Insect/Analysis/
#因内存有限，取部分序列（2百万条序列）做拼接组装工作
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
		my $fq1=$a[1];my $fq2=$a[2];
	my $Keyname=$a[0];
	if($n>2){
			system "seqkit split2 -s 2000000 -1 $fq1 -2 $fq2 -O ./\n";
			my $n1=substr(basename($fq1),0,length(basename($fq1))-6).".part_001.fastq";
			my $n2=substr(basename($fq2),0,length(basename($fq1))-6).".part_001.fastq";
                system "spades.py -1 $n1 -2 $n2 -o $Keyname --meta \n";
	}else{
		system "seqkit split2 -s 2000000 -1 $fq1 -O ./\n";
		my $n1=substr(basename($fq1),0,length(basename($fq1))-6).".part_001.fastq";
		system "spades.py -s $n1 -o $Keyname --meta -m 128\n";
	}
	system "rm -rf *.fastq\n";
        my $genome=$Keyname.".assembled.fasta";
        system "seqkit seq -m 1000 $Keyname/scaffolds.fasta >$genome\n";
     #   system "cp $Keyname/scaffolds.fasta $Outdir/WGS_Report/$Keyname.assembled.fasta\n";
#       system "conda activate metaphlan\n";
        system "/home/zhangwen/bin/bowtie2-2.4.4-linux-x86_64/bowtie2-build  $genome $genome\n";
   system "/home/zhangwen/bin/bowtie2-2.4.4-linux-x86_64/bowtie2  -x $genome -1 $fq1 -2 $fq2 | samtools sort -o $Keyname.sort.bam  \n";
#   system "conda deactivate\n";
   system "jgi_summarize_bam_contig_depths --outputDepth $Keyname.depth.txt $Keyname.sort.bam\n";
   system "metabat2 -i $genome -a $Keyname.depth.txt -o $Keyname\n";
  system "rm -rf $Keyname\n";


	
}
close F;