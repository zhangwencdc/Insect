#!/usr/bin/perl
use strict;
use warnings;

my $file = "SraAccList_info_filter-v2.csv";
my $dir = "/home/zhangwen/project/2024Insect/RawData/";

open(my $fh, "<", $file) or die "Cannot open file: $!";
my $header = <$fh>;
chomp $header;

while (my $line = <$fh>) {
    chomp $line;
    my @fields = split(" ", $line);
    my $name = $fields[0];
	unless(substr($name,length($name)-1,1)=~/[0-9a-zA-Z]/){$name=substr($name,0,length($name)-1);}
    my $full_path = $dir . $name."*fastq";
   # print "$full_path\n";
    
    my @fq = glob($full_path);

  
        print "$name\t@fq\n";

}

close $fh;
