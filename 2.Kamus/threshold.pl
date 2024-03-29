use strict;
use File::Basename;

my ( $lokasiKamus1, $lokasiKamus2, $treshold) = @ARGV;
if (!$treshold) {
  print "Cara jalankan: $0 <kamus1> <kamus2> <tresshold>\n";
  exit;
}

$treshold /=100;

my $namaKamus1= basename($lokasiKamus1,'txt'); 
my $namaKamus2= basename($lokasiKamus2, 'txt');

my $kamus1 = `cat $lokasiKamus1`;
my $kamus2 = `cat $lokasiKamus2`;

# Masukkan kamus 1 kedalam hash kamus 1
my %kamusHash1;
my @dataKamus1 = split("\n", $kamus1);

foreach my $data (@dataKamus1) {
	my ($freq, $norm, $kata) = split ("\t", $data);
	$kamusHash1{$kata} = $norm;
}

# Masukkan kamus 2 kedalam hash kamus 2
my %kamusHash2;
my @dataKamus2 = split("\n", $kamus2);

foreach my $data (@dataKamus2) {
	my ($freq, $norm, $kata) = split ("\t", $data);
	$kamusHash2{$kata} = $norm;
}


foreach my $kata (keys %kamusHash1) {
	my $th;
	if($kamusHash2{$kata}) {
		if ($kamusHash2{$kata} >= $kamusHash1{$kata}) {
			$th = $kamusHash1{$kata}/$kamusHash2{$kata};
		} else {
			$th = $kamusHash2{$kata}/$kamusHash1{$kata};
		}
		# print "$kata == $th\n";
		if ($th >= $treshold) {
			delete $kamusHash1{$kata};
			delete $kamusHash2{$kata};
		} else {
			if ($kamusHash1{$kata} > $kamusHash2{$kata}) {
				delete $kamusHash2{$kata};
			} else {
				delete $kamusHash1{$kata};
			}
		}
	}
}

$treshold*=100;
my $DIR = "kamus-bersih/$treshold%";

unless (-e $DIR and -d $DIR) {
	system "mkdir $DIR";
}

open OUT, "> $DIR/clean-$namaKamus1-$treshold%.txt";
foreach my $kata (keys %kamusHash1) {
	print OUT "$kamusHash1{$kata}\t$kata\n";
}
close OUT;

open OUT, "> $DIR/clean-$namaKamus2-$treshold%.txt";
foreach my $kata (keys %kamusHash2) {
	print OUT "$kamusHash2{$kata}\t$kata\n";
}
close OUT;