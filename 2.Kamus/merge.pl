use strict;
use warnings;
use File::Basename;


my $file = $ARGV[0];
my $file2 = $ARGV[1];
if (! $file) {
  print "Cara jalankan: $0 <file>\n";
  exit;
}

open OUT, ">lala.txt";
my $data = `cat $file`;
my $data2 = `cat $file2`;
my @kamus = split /\n/, $data;
my @kamus2 = split /\n/, $data2;

$file = basename($file);

my $maksimum = 0;
my %hash1;
my %hash2;



foreach my $dict (@kamus) {
	my ($frekuensi, $kata) = split ("\t", $dict);
    # open FILE, "> merge/$file";
    # print FILE "$kata";
    $hash1{$kata} =$frekuensi;
    # print $hash1{$kata};
    
}

foreach my $dict (@kamus2){
	my ($frekuensi, $kata) = split /\t/, $dict;
  $hash2{$kata} = $frekuensi;
  # print $kata;
  # print $frekuensi;
  # print %hash1;
  # if ($hash1{$kata}){
  #   $hash1{$kata}+=$frekuensi;
  # }
  
}

foreach my $word (keys %hash1, keys %hash2){
    # print "$hash1{$word}\t$word\n";
    if ($hash1{$word}){
      $hash1{$word} +=$hash2{$word};
    } else {
      $hash1{$word} =1;
    }
    print OUT "$hash1{$word}\t $word\n";
  }
# foreach my $dict (@kamus) {
# 	my ($frekuensi, $kata) = split /\t/, $dict;
	
# 	my $normalisasi= $frekuensi/$maksimum;
# 	print FILE "$frekuensi\t$normalisasi\t$kata\n";
# }