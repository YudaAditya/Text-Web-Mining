use strict;
use warnings;
use Lingua::EN::Bigram;

my $FILEOUT = $ARGV[0] or die "Harap Masukkan File hasil beserta extensi file dalam Format .arff";
my $FILETH = $ARGV[1] or die "Harap Masukkan Threshold";
my $kamus1gr_fiction = `cat kamus-bersih/$FILETH%/clean-1-gram-data-fiction.-$FILETH%.txt`;
my $kamus2gr_fiction = `cat kamus-bersih/$FILETH%/clean-2-gram-data-fiction.-$FILETH%.txt`;
my $kamus3gr_fiction = `cat kamus-bersih/$FILETH%/clean-3-gram-data-fiction.-$FILETH%.txt`;
my $kamus1gr_fantasy = `cat kamus-bersih/$FILETH%/clean-1-gram-data-fantasy.-$FILETH%.txt`;
my $kamus2gr_fantasy = `cat kamus-bersih/$FILETH%/clean-2-gram-data-fantasy.-$FILETH%.txt`;
my $kamus3gr_fantasy = `cat kamus-bersih/$FILETH%/clean-3-gram-data-fantasy.-$FILETH%.txt`;
my $kamus1gr_mistery = `cat kamus-bersih/$FILETH%/clean-1-gram-data-mistery.-$FILETH%.txt`;
my $kamus2gr_mistery = `cat kamus-bersih/$FILETH%/clean-2-gram-data-mistery.-$FILETH%.txt`;
my $kamus3gr_mistery = `cat kamus-bersih/$FILETH%/clean-3-gram-data-mistery.-$FILETH%.txt`;

my $PATH_fiction = "fiction";
my $PATH_fantasy = "fantasy";
my $PATH_mistery = "mistery";

######fiction#######
my %hash1gr_fiction;
my @dataKamus1gr_fiction = split("\n",$kamus1gr_fiction);
print "\nLoad Kamus 1 fiction\n";

foreach my $data(@dataKamus1gr_fiction){
    my ($freq, $kata) = split("\t",$data);
    $hash1gr_fiction{$kata} = $freq;
}


my %hash2gr_fiction;
my @dataKamus2gr_fiction = split("\n", $kamus2gr_fiction);
print "\nLoad Kamus 2 fiction\n";

foreach my $data (@dataKamus2gr_fiction){
    my ($freq, $kata) = split ("\t",$data);
    $hash2gr_fiction{$kata} = $freq;
}

my %hash3gr_fiction;
my @dataKamus3gr_fiction = split("\n", $kamus3gr_fiction);
print "\nLoad Kamus 3 fiction\n";

foreach my $data (@dataKamus3gr_fiction){
    my ($freq, $kata) = split ("\t",$data);
    $hash3gr_fiction{$kata} = $freq;
}

#####fantasy######

my %hash1gr_fantasy;
my @dataKamus1gr_fantasy = split("\n", $kamus1gr_fantasy);
print "\nLoad Kamus 1 fantasy\n";

foreach my $data (@dataKamus1gr_fantasy){
    my ($freq, $kata) = split ("\t",$data);
    $hash1gr_fantasy{$kata} = $freq;
}

my %hash2gr_fantasy;
my @dataKamus2gr_fantasy = split("\n", $kamus2gr_fantasy);
print "\nLoad Kamus 2 fantasy\n";

foreach my $data (@dataKamus2gr_fantasy){
    my ($freq, $kata) = split ("\t",$data);
    $hash2gr_fantasy{$kata} = $freq;
}

my %hash3gr_fantasy;
my @dataKamus3gr_fantasy = split("\n", $kamus3gr_fantasy);
print "\nLoad Kamus 3 fantasy\n";

foreach my $data (@dataKamus3gr_fantasy){
    my ($freq, $kata) = split ("\t",$data);
    $hash3gr_fantasy{$kata} = $freq;
}

#####mistery######

my %hash1gr_mistery;
my @dataKamus1gr_mistery = split("\n", $kamus1gr_mistery);
print "\nLoad Kamus 1 mistery\n";

foreach my $data (@dataKamus1gr_mistery){
    my ($freq, $kata) = split ("\t",$data);
    $hash1gr_mistery{$kata} = $freq;
}

my %hash2gr_mistery;
my @dataKamus2gr_mistery = split("\n", $kamus2gr_mistery);
print "\nLoad Kamus 2 mistery\n";

foreach my $data (@dataKamus2gr_mistery){
    my ($freq, $kata) = split ("\t",$data);
    $hash2gr_mistery{$kata} = $freq;
}

my %hash3gr_mistery;
my @dataKamus3gr_mistery = split("\n", $kamus3gr_mistery);
print "\nLoad Kamus 3 mistery\n";

foreach my $data (@dataKamus3gr_mistery){
    my ($freq, $kata) = split ("\t",$data);
    $hash3gr_mistery{$kata} = $freq;
}



print "Load Data\n";

my $ngrams = Lingua::EN::Bigram->new;

my $count1gr_fiction;
my $count2gr_fiction;
my $count3gr_fiction;
my $count1gr_fantasy;
my $count2gr_fantasy;
my $count3gr_fantasy;
my $count1gr_mistery;
my $count2gr_mistery;
my $count3gr_mistery;

my $hasil_fiction1;
my $hasil_fiction2;
my $hasil_fiction3;
my $hasil_fantasy1;
my $hasil_fantasy2;
my $hasil_fantasy3;
my $hasil_mistery1;
my $hasil_mistery2;
my $hasil_mistery3;

my @datas=("fiction","fantasy","mistery");
my $title;
my $atas;
my $tengah1;
my $tengah2;
my $bawah;

my %stopwords;
loadStopwords(\%stopwords);
# my $title;


open FILE, ">$FILEOUT-$FILETH%.arff" or die "Tidak dapat membuat file";

my $relation = '@relation fiction-fantasy-mistery'."\n\n";
print FILE "$relation";

my $data_type = "numeric";	
for(my $number =1; $number<=45; $number++){
	my $attribute = '@attribute content'."$number"." $data_type";
	print FILE "$attribute\n";
}
print FILE '@attribute class {fiction,fantasy,mistery}'."\n\n";

print FILE '@data'."\n";
foreach my $data(@datas){
	my %hash;
	my $file=`ls -v $data`;
	my @files=split("\n", $file);

	foreach my $file(@files){
		my $content="";
		my $teks =`cat $data/$file`;

		$teks =~ /<title>([\s\S]*)<\/title>/;
		$title =$1;
		$teks=~ /<atas>([\s\S]*)<\/atas>/;
		$atas=$1;
		$teks=~ /<tengah1>([\s\S]*)<\/tengah1>/;
		$tengah1 =$1;
		$teks=~ /<tengah2>([\s\S]*)<\/tengah2>/;
		$tengah2 =$1;
		$teks=~ /<bawah>([\s\S]*)<\/bawah>/;
		$bawah=$1;

	my @isi=($title, $atas, $tengah1,$tengah2, $bawah);
		for(my $i=1; $i<=5; $i++){
				for(my $j=1; $j<4; $j++){				
						$count1gr_fiction =0;
						$count2gr_fiction =0;
						$count3gr_fiction =0;
						$count1gr_fantasy =0;
						$count2gr_fantasy =0;
						$count3gr_fantasy =0;
						$count1gr_mistery =0;
						$count2gr_mistery =0;
						$count3gr_mistery =0;
						$hasil_fiction1 =0;
						$hasil_fiction2 =0;
						$hasil_fiction3 =0;
						$hasil_fantasy1 =0;
						$hasil_fantasy2 =0;
						$hasil_fantasy3 =0;
						$hasil_mistery1 =0;
						$hasil_mistery2 =0;
						$hasil_mistery3 =0;

					print "\nMemproses bagian ke $i,$j \n";
					$ngrams->text($isi[$i]);
						my @ngrams_array=$ngrams->ngram($j);

						foreach my $gram (@ngrams_array){

							if($j==1){
								next if ( $gram eq '');
								next if ( $stopwords{ $gram } );
								next if ( $gram =~ /[,.?!:;()\-'']/ );

								if($hash{$gram}){
									$hash{$gram} += 1;
								} else {
									$hash{$gram} = 1;
								}

								if($hash1gr_fiction{$gram}){
									$count1gr_fiction++;
								}
								if($hash1gr_fantasy{$gram}){
									$count1gr_fantasy++;
								}
								if($hash1gr_mistery{$gram}){
									$count1gr_mistery++;
								}
							}elsif($j == 2){
								my ( $first_token, $second_token ) = split / /, $gram;
					
								# skip stopwords and punctuation
								next if ( $first_token eq '');
								next if ( $second_token eq '');
								next if ( $stopwords{ $first_token } );
								next if ( $first_token =~ /[,.?!:;()\-'']/ );
								next if ( $stopwords{ $second_token } );
								next if ( $second_token =~ /[,.?!:;()\-'']/ );

								#cek apakah kata ada dalam hash
								if($hash{$gram}){
									$hash{$gram} += 1;
								} else {
									$hash{$gram} = 1;
								}

								if($hash2gr_fiction{$gram}){
									$count2gr_fiction++;
								}
								if($hash2gr_fantasy{$gram}){
									$count2gr_fantasy++;
								}
								if($hash2gr_mistery{$gram}){
									$count2gr_mistery++;
								}
							}
							else{
								my ( $first_token, $second_token, $third_token ) = split / /, $gram;
					
								# skip stopwords and punctuation
								next if ( $first_token eq '');
								next if ( $second_token eq '');
								next if ( $third_token eq '');
								next if ( $stopwords{ $first_token } );
								next if ( $first_token =~ /[,.?!:;()\-'']/ );
								next if ( $stopwords{ $second_token } );
								next if ( $second_token =~ /[,.?!:;()\-'']/ );
								next if ( $stopwords{ $third_token } );
								next if ( $third_token =~ /[,.?!:;()\-'']/ );

								#cek apakah kata ada dalam hash
								if($hash{$gram}){
									$hash{$gram} += 1;
								} else {
									$hash{$gram} = 1;
								}
								
								if($hash3gr_fiction{$gram}){
									$count3gr_fiction++;
								}
								if($hash3gr_fantasy{$gram}){
									$count3gr_fantasy++;
								}
								if($hash3gr_mistery{$gram}){
									$count3gr_mistery++;
								}
							}
						}

						if($j==1){
							my $total1gram = @ngrams_array;
							if($total1gram==0){
								$hasil_fiction1 =0;
								$hasil_fantasy1 =0;
								$hasil_mistery1 =0;
								print FILE "$hasil_fiction1,$hasil_fantasy1,$hasil_mistery1,";
							} else{
								$hasil_fiction1 = $count1gr_fiction/$total1gram;
								$hasil_fantasy1 = $count1gr_fantasy/$total1gram;
								$hasil_mistery1 = $count1gr_mistery/$total1gram;
								print FILE "$hasil_fiction1,$hasil_fantasy1,$hasil_mistery1,";
							}						
						}elsif($j==2){
							my $total2gram = @ngrams_array;
							if($total2gram==0){
								$hasil_fiction2 =0;
								$hasil_fantasy2 =0;
								$hasil_mistery2 =0;
								print FILE "$hasil_fiction2,$hasil_fantasy2,$hasil_mistery2,";
							} else{
								$hasil_fiction2 = $count2gr_fiction/$total2gram;
								$hasil_fantasy2 = $count2gr_fantasy/$total2gram;
								$hasil_mistery2 = $count2gr_mistery/$total2gram;
								print FILE "$hasil_fiction2,$hasil_fantasy2,$hasil_mistery2,";
							}
						}else{
							my $total3gram =@ngrams_array;
							if($total3gram==0){
								$hasil_fiction3 =0;
								$hasil_fantasy3 =0;
								$hasil_mistery3 =0;
								print FILE "$hasil_fiction3,$hasil_fantasy3,$hasil_mistery3,";
							} else{
								$hasil_fiction3 = $count3gr_fiction/$total3gram;
								$hasil_fantasy3 = $count3gr_fantasy/$total3gram;
								$hasil_mistery3 = $count3gr_mistery/$total3gram;
								print FILE "$hasil_fiction3,$hasil_fantasy3,$hasil_mistery3,";
							}
						}
					}
				}print FILE"$data\n";
			}
			print "Selesai ...";
		}
	close FILE;
# load stopword function
sub loadStopwords 
{
  my $hashref = shift;
  open IN, "< stopwords-en.txt" or die "Cannot Open File!!!";
  while (<IN>)
  {
    chomp;
    if(!defined $$hashref{$_})
    {
       $$hashref{$_} = 1;
    }
  }  
}
