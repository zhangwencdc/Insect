#!/usr/bin/perl
use strict;
use warnings;
#docker run --privileged=true -it -v /home/zhangwen/project/2024Insect/:/test kingfisher:v1
#conda activate kingfisher

my $acclist = $ARGV[0]; # SraAccList_info_filter-v2.csv
my $list=$ARGV[1];#Downloaded.list
my $outdir=$ARGV[2];#/test/2
my %d;
open(FILE,$list);
while(1){
	my $l=<FILE>;
	unless($l){last;}
	chomp $l;
	my @a=split"_",$l;
	if($a[0]=~/fastq/){$a[0]=substr($a[0],0,length($a[0])-6);}
	$d{$a[0]}++;
}
close FILE;

open(F, $acclist) or die "Cannot open file $acclist: $!";
while (my $l = <F>) {
    chomp $l;
    my @a = split /\t/, $l;
	$a[0]=~ s/\s//g;
    if ($a[0] eq "run") {
        next;
    }
#	print "$a[0],$d{$a[0]}\n";
	if(exists $d{$a[0]}){next;}
    system "/kingfisher-download/bin/kingfisher get -r $a[0] -f fastq -m ena-ftp prefetch aws-http --check-md5sums --output-directory $outdir\n";
}
close F;
