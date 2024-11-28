#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use FindBin qw($Bin);
use File::Basename qw(basename dirname);
use Data::Dumper;
use File::Path;  
use Cwd;
my $path = getcwd;
#Usage:基于raw data的污水样本检测
#依赖Kraken2、Braken、Blat、Bowtie2、spades
##
my ($Keyname,$Ref,$input,$database,$type,$fa,$r,$level,$Outdir,$verbose,$db,$snp,$fq1,$fq2,$marker);
my ($Verbose,$Help);


GetOptions(
        "R:s"=>\$Ref, #参考基因组
        "L|level:s"=>\$level,  #默认Level: S  ,S代表Species，也可以设置为G，代表Genus
        "Out|O:s"=>\$Outdir,
        "verbose"=>\$Verbose,
        "Tag|Key:s" =>\$Keyname,
		"r|rlen:s" =>\$r,
		"database|DB:s"=>\$db,###比对数据库
		"1|Fq1:s"=>\$fq1,###必选 fq1
		"2|Fq2:s"=>\$fq2,###fq2
		"M|marker:s"=>\$marker,###marker
        "help"=>\$Help
);
####
$Keyname ||= "Input";
$Outdir ||= ".";
$type ||=1;
#$level ||="S";
$r ||=150;

die `pod2text $0` if ($Help);

if(substr($fq1,length($fq1)-3,3)=~/.gz/){system "gunzip $fq1\n";$fq1=substr($fq1,0,length($fq1)-3);}
if(defined $fq2){if(substr($fq2,length($fq2)-3,3)=~/.gz/){system "gunzip $fq2\n";$fq2=substr($fq2,0,length($fq2)-3);}}
###Bracken
print "Kraken2 searching\n";
if(defined $fq2){
	print "kraken2 --db /home/zhangwen/Data/Kraken2/minikraken2_v2_8GB_201904_UPDATE/ --report $Outdir/$Keyname.report --output $Outdir/$Keyname.kraken --paired $fq1 $fq2\n";
	system "kraken2 --db /home/zhangwen/Data/Kraken2/minikraken2_v2_8GB_201904_UPDATE/ --report $Outdir/$Keyname.report --output $Outdir/$Keyname.kraken --paired $fq1 $fq2\n";
	system "bracken -d /home/zhangwen/Data/Kraken2/minikraken2_v2_8GB_201904_UPDATE -i $Outdir/$Keyname.report -o $Outdir/$Keyname.report.bracken.species  -l S -r $r\n";
	system "bracken -d /home/zhangwen/Data/Kraken2/minikraken2_v2_8GB_201904_UPDATE -i $Outdir/$Keyname.report -o $Outdir/$Keyname.report.bracken.genus  -l G -r $r\n";
	#system "perl /home/zhangwen/bin/kraken2-translate.pl $Outdir/$Keyname.report >$Outdir/$Keyname.report.txt\n";
	#system "ktImportText $Outdir/$Keyname.report.txt -o $Outdir/$Keyname.kraken.html";
}else{
	system "kraken2 --db /home/zhangwen/Data/Kraken2/minikraken2_v2_8GB_201904_UPDATE/ --report $Outdir/$Keyname.report --output $Outdir/$Keyname.kraken $fq1 \n";
	system "bracken -d /home/zhangwen/Data/Kraken2/minikraken2_v2_8GB_201904_UPDATE -i $Outdir/$Keyname.report -o $Outdir/$Keyname.report.bracken.species  -l S -r $r\n";
	system "bracken -d /home/zhangwen/Data/Kraken2/minikraken2_v2_8GB_201904_UPDATE -i $Outdir/$Keyname.report -o $Outdir/$Keyname.report.bracken.genus  -l G -r $r\n";
	#system "perl /home/zhangwen/bin/kraken2-translate.pl $Outdir/$Keyname.report >$Outdir/$Keyname.report.txt\n";
	#system "ktImportText $Outdir/$Keyname.report.txt -o $Outdir/$Keyname.kraken.html";
}
system "rm $Outdir/$Keyname.kraken\n";
###VFF
print "Virulent factor searching\n";
if(defined $fq2){
	#system "perl /home/zhangwen/bin/Target_bowtie-dell-Micro-v2.pl -1 $fq1 -2 $fq2 -T /home/zhangwen/Data/VFF/VFDB_setA_nt.fas -o $Keyname.vff.setA\n ";
	system "perl /home/zhangwen/bin/Target_bowtie-dell-Micro-v2.pl -1 $fq1 -2 $fq2 -T /home/zhangwen/Data/VFF/VFDB_setB_nt.fas -o $Outdir/$Keyname.vff.setB\n ";
}else{
	#system "perl /home/zhangwen/bin/Target_bowtie-dell-Micro-v2.pl -1 $fq1 -T /home/zhangwen/Data/VFF/VFDB_setA_nt.fas -o $Keyname.vff.setA\n ";
	system "perl /home/zhangwen/bin/Target_bowtie-dell-Micro-v2.pl -1 $fq1 -T /home/zhangwen/Data/VFF/VFDB_setB_nt.fas -o $Outdir/$Keyname.vff.setB\n ";
}
system "rm $Outdir/$Keyname.*vff*.sam* $Outdir/$Keyname.*vff*.bam* $Outdir/$Keyname.*vff*fasta\n";

print "7 important vff searching\n";
if(defined $fq2){
	
	system "perl /home/zhangwen/bin/Target_bowtie-dell-Micro-v2.pl -1 $fq1 -2 $fq2 -T /home/zhangwen/Data/VFF/VFF_from_PULSENET.fa -o $Outdir/$Keyname.vff.pulsenet\n ";
}else{
	
	system "perl /home/zhangwen/bin/Target_bowtie-dell-Micro-v2.pl -1 $fq1 -T /home/zhangwen/Data/VFF/VFF_from_PULSENET.fa -o $Outdir/$Keyname.vff.pulsenet\n ";
}
system "rm $Outdir/$Keyname.*vff*.sam* $Outdir/$Keyname.*vff*.bam* $Outdir/$Keyname.*vff*fasta\n";
##Resistance
print "Resistance genes searching\n";
if(defined $fq2){
	system "perl  /home/zhangwen/bin/Target_bowtie-dell-Micro-v2.pl -T /home/zhangwen/bin/Resistance/res.fas -1 $fq1 -2 $fq2 -o $Outdir/$Keyname.res \n ";
}else{
	system "perl  /home/zhangwen/bin/Target_bowtie-dell-Micro-v2.pl -T /home/zhangwen/bin/Resistance/res.fas -1 $fq1 -o $Outdir/$Keyname.res \n ";
}
#system "cp $Keyname.bam.sort.coverage $Keyname.res.report\n";
system "rm  $Outdir/$Keyname.*.sam* $Outdir/$Keyname.*.bam* $Outdir/$Keyname.*res*fasta\n";
###宿主鉴定
print "Host searching\n";
if(defined $fq2){
	system "perl  /home/zhangwen/bin/Target_bowtie-dell-Micro-v2.pl  -1 $fq1 -2 $fq2 -o $Outdir/$Keyname.host -T /home/zhangwen/Data/Mitochondrion/Mitochondrion.fasta\n ";
}else{
	system "perl  /home/zhangwen/bin/Target_bowtie-dell-Micro-v2.pl  -1 $fq1 -o $Outdir/$Keyname.host -T /home/zhangwen/Data/Mitochondrion/Mitochondrion.fasta\n ";
}
system "rm $Outdir/$Keyname.*.sam* $Outdir/$Keyname.*.bam* $Outdir/$Keyname.*host*.fasta\n";

###拼接组装
print "Spades Assembling\n";
if(defined $fq2){
	system "spades.py -1 $fq1 -2 $fq2 --meta -o $Outdir/$Keyname.spades\n";

}else{
	system "spades.py -1 $fq1 --meta -o $Outdir/$Keyname.spades\n";
}
	system "seqkit seq -m 1000 $Outdir/$Keyname.spades/scaffolds.fasta >$Outdir/$Keyname.spades.fasta \n";
#system "rm -rf $Keyname.spades\n";


##DRM marker
my $data="/home/zhangwen/Data/2023Genome_Database/Marker/Marker-v6.fasta"; #PathogenCore marker基因的合并文件 大于1000bp

open(F,$data);my %anno;
my %species;
while(1){
		my $line=<F>;
		unless($line){last;}
		chomp $line;
		unless(substr($line,0,1) eq ">"){next;}
		my @b=split".fna_",$line;
		my $species=pop @b;
		$species{$species}++;
		$anno{substr($line,1)}=$species;
}
close F;
system "blat $data $Outdir/$Keyname.spades.fasta  $Outdir/tmp.blat";
	open(F,"$Outdir/tmp.blat");
	open(OUT,">$Outdir/$Keyname.DRM.blat\n");
		print OUT "Filename\tMarker\tSeqID\tAlignLength\tGeneLength\n";
	while(1){
		my $line=<F>;
		unless($line){last;}
		chomp $line;
		my @a=split"\t",$line; 
		unless($a[0]>0){next;}
		if($a[0]>=$a[14]*0.3 || $a[0]>=300){print OUT "$Keyname\t$a[13]\t$a[9]\t$a[0]\t$a[14]\n";}
	}
	close F;
	system "rm -rf $Outdir/tmp.blat\n";

print "Success Finished\n";
