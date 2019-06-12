use strict;
use warnings;
use File::Basename;


my $file = $ARGV[0];
if (! $file) {
  print "Cara jalankan: $0 <file>\n";
  exit;
}

my $data = `cat $file`;
my @kamus = split /\n/, $data;

$file = basename($file);

my $maksimum = 0;

foreach my $dict (@kamus) {
	my ($frekuensi, $kata) = split /\t/, $dict;

	if ($frekuensi > $maksimum) {
		$maksimum=$frekuensi;
	}
}


open FILE, "> normalize/$file";

foreach my $dict (@kamus) {
	my ($frekuensi, $kata) = split /\t/, $dict;
	
	my $normalisasi= $frekuensi/$maksimum;
	print FILE "$frekuensi\t$normalisasi\t$kata\n";
}