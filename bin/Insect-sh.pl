#!/usr/bin/perl
use strict;
use warnings;
#docker run -it  --privileged=true -v /home/zhangwen/:/test wgs:v2
#cd /test/project/2024Insect/Analysis/

my $file=$ARGV[0];#Insect_Seq.list
my $script="/test/Data/WGS_docker/wgsqc_docker.pl";
my $data="/test/Data/WGS_docker/";
open(F,$file);
my $header=<F>;chomp $header;
while(1){
	my $l=<F>;
	unless($l){last;}
	chomp $l;
	my @a=split"\t",$l;
	my $n=@a;
	if($n>2){
		print "perl $script -1 $a[1] -2 $a[2] -database $data -K $a[0] -O ./ -Res -VF -Assemble -V -H -NH\n";
	}else{
		print "perl $script -1 $a[1] -database $data -K $a[0] -O ./ -Res -VF -Assemble -V -H -NH\n";
	}
}
close F;