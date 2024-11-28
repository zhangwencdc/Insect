#!/usr/bin/perl
use strict;
use warnings;
#docker run --privileged=true -it -v /home/zhangwen/project/2024Insect/:/test kingfisher:v1
#conda activate kingfisher

my $acclist = $ARGV[0]; # SraAccList_info_filter-v2.csv
open(F, $acclist) or die "Cannot open file $acclist: $!";
while (my $l = <F>) {
    chomp $l;
    my @a = split /\t/, $l;
    if ($a[0] eq "run") {
        next;
    }

    system "/kingfisher-download/bin/kingfisher get -r $a[0] -f fastq -m ena-ftp prefetch aws-http --check-md5sums --output-directory /test/Download2\n";
}
close F;
