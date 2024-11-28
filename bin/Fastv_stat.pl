use strict;  
use warnings;  
use JSON;  

# ��ȡ������JSON�ļ�  
my @file=glob "$ARGV[0]/*.json";
open(OUT,">$ARGV[1]");
foreach my $filename (@file) {

open my $fh, '<', $filename or die "Could not open file '$filename' $!";  
my $json_text = do {  
    local $/;  # Enable 'slurp' mode  
    <$fh>  
};  
close $fh;  

my $data = decode_json($json_text);  

# ��ȡ��Ϣ  
my $info=$data->{kmer_collection_scan_result};

# ��ӡ��ȡ����Ϣ  
# ������ļ�  
#open my $out_fh, '>', 'output.txt' or die "Could not open file 'output.txt' $!";  

# ��ȡ��д����Ϣ  
	foreach my $virus (keys %{$data->{kmer_collection_scan_result}}) {  
		my $info = $data->{kmer_collection_scan_result}{$virus};  
		print OUT "$filename\t";
		print OUT "$virus\t";  
		print  OUT "$info->{coverage}\t";  
		print OUT  "$info->{kmer_count}\t";  
		print OUT "$info->{kmer_hits}\t";  
		print OUT "$info->{median_depth}\t";  
		print  OUT "$info->{mean_depth}\t";  
		print OUT "\n"; # �����Էָ�������Ŀ  
	}  
}