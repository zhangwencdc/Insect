use strict;  
use warnings;  
use JSON;  

# 读取并解码JSON文件  
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

# 提取信息  
my $info=$data->{kmer_collection_scan_result};

# 打印提取的信息  
# 打开输出文件  
#open my $out_fh, '>', 'output.txt' or die "Could not open file 'output.txt' $!";  

# 提取并写入信息  
	foreach my $virus (keys %{$data->{kmer_collection_scan_result}}) {  
		my $info = $data->{kmer_collection_scan_result}{$virus};  
		print OUT "$filename\t";
		print OUT "$virus\t";  
		print  OUT "$info->{coverage}\t";  
		print OUT  "$info->{kmer_count}\t";  
		print OUT "$info->{kmer_hits}\t";  
		print OUT "$info->{median_depth}\t";  
		print  OUT "$info->{mean_depth}\t";  
		print OUT "\n"; # 空行以分隔各个条目  
	}  
}