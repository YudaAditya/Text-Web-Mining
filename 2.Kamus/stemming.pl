use lib '../lib';
use strict;
use Lingua::Stem::Snowball;
use File::Basename;


# my @datas = ("samsung","apple");
my $stemmed;
my $data = $ARGV[0] or die "Masukkan Folder sumber...";
my $PATHCLEAN = $ARGV[1] or die "Masukkan folder Hasil....";

# foreach my $data (@datas) {

	my %kata;

	my $files = `ls -v $data/`;

	my @listFile = split('\n',$files);

	# open OUT, "> hasil/Stemming-gram-data-$data.txt"  or die "File tidak dapat dibuka/dibuat...";

	
	foreach my $isidir (@listFile) {
		my $file = "$data/$isidir";
  		my $fileout = basename($file)."-stemming.dat";
  		$fileout = "$PATHCLEAN/$fileout";
		open OUT, "> $fileout" or die "Cannot Open File!!!";
		
		# open F, $file or die "Can't open input: $!\n";
		my $texts = `cat $data/$isidir`;
		# close F;
		# print $texts;
		

		my $text = $texts;
		$text = lc $text;
		my @stemText = split(' ',$text);
		my $stemmer = Lingua::Stem::Snowball->new( lang => 'en' );
        $stemmer->stem_in_place( \@stemText );
		foreach my $isi (@stemText){
			$stemmed = "$isi ";
        print OUT "$isi\n";
		}
    }
# } #lanjutin buat simpen ke file masing2 jangan 1 file, ikut code exctrac content