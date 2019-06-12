use strict;
use warnings;
use Lingua::EN::Bigram;

my $FILEOUT = $ARGV[0] or die "Harap Masukkan File hasil berekstensi .dat";
my $FILETH = $ARGV[1] or die "Harap Masukkan Threshold";
my $kamus1gr_fantasy = `cat kamus-bersih/$FILETH%/2.Fantasy-mistery/clean-1-gram-data-fantasy.-$FILETH%.txt`;
my $kamus2gr_fantasy = `cat kamus-bersih/$FILETH%/2.Fantasy-mistery/clean-2-gram-data-fantasy.-$FILETH%.txt`;
my $kamus3gr_fantasy = `cat kamus-bersih/$FILETH%/2.Fantasy-mistery/clean-2-gram-data-fantasy.-$FILETH%.txt`;
my $kamus1gr_mistery = `cat kamus-bersih/$FILETH%/2.Fantasy-mistery/clean-1-gram-data-mistery.-$FILETH%.txt`;
my $kamus2gr_mistery = `cat kamus-bersih/$FILETH%/2.Fantasy-mistery/clean-2-gram-data-mistery.-$FILETH%.txt`;
my $kamus3gr_mistery = `cat kamus-bersih/$FILETH%/2.Fantasy-mistery/clean-3-gram-data-mistery.-$FILETH%.txt`;

my $PATH_fantasy = "fantasy";
my $PATH_mistery = "mistery";

######fantasy#######
my %hash1gr_fantasy;
my @dataKamus1gr_fantasy = split("\n",$kamus1gr_fantasy);
print "\nLoad Kamus 1 fantasy\n";

foreach my $data(@dataKamus1gr_fantasy){
    my ($freq, $kata) = split("\t",$data);
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
    $hash2gr_fantasy{$kata} = $freq;
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

my $count1gr_fantasy;
my $count2gr_fantasy;
my $count3gr_fantasy;
my $count1gr_mistery;
my $count2gr_mistery;
my $count3gr_mistery;
my $hasil_fantasy1;
my $hasil_fantasy2;
my $hasil_fantasy3;
my $hasil_mistery1;
my $hasil_mistery2;
my $hasil_mistery3;

my @datas=("fantasy","mistery");
my $title;
my $atas;
my $tengah1;
my $tengah2;
my $bawah;
my $count=0;

my %stopwords;
loadStopwords(\%stopwords);
# my $title;

open FILE, ">$FILEOUT-$FILETH%.dat" or die "Tidak dapat membuat file";

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

        if ($count == 0){
            print FILE "+1 ";
        } else{
            print FILE "-1 ";
        }

	my @isi=($title, $atas, $tengah1,$tengah2, $bawah);
	my $num_ganjil =1;
	my $num_genap =2;
		for(my $i=1; $i<=5; $i++){
				for(my $j=1; $j<4; $j++){				
						$count1gr_fantasy =0;
						$count2gr_fantasy =0;
						$count3gr_fantasy =0;
						$count1gr_mistery =0;
						$count2gr_mistery =0;
						$count3gr_mistery =0;
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
								$hasil_fantasy1 =0;
								$hasil_mistery1 =0;
								print FILE "$num_ganjil:$hasil_fantasy1 $num_genap:$hasil_mistery1 ";
							} else{
								$hasil_fantasy1 = $count1gr_fantasy/$total1gram;
								$hasil_mistery1 = $count1gr_mistery/$total1gram;
								print FILE "$num_ganjil:$hasil_fantasy1 $num_genap:$hasil_mistery1 ";
							}						
						}elsif($j==2){
							$num_ganjil += 2;
							$num_genap += 2;
							my $total2gram = @ngrams_array;
							if($total2gram==0){
								$hasil_fantasy2 =0;
								$hasil_mistery2 =0;
								print FILE "$num_ganjil:$hasil_fantasy2 $num_genap:$hasil_mistery2 ";
							} else{
								$hasil_fantasy2 = $count2gr_fantasy/$total2gram;
								$hasil_mistery2 = $count2gr_mistery/$total2gram;
								print FILE "$num_ganjil:$hasil_fantasy2 $num_genap:$hasil_mistery2 ";
							}
						}else{
							$num_ganjil += 2;
							$num_genap += 2;
							my $total3gram =@ngrams_array;
							if($total3gram==0){
								$hasil_fantasy3 =0;
								$hasil_mistery3 =0;
								print FILE "$num_ganjil:$hasil_fantasy3 $num_genap:$hasil_mistery3 ";
							} else{
								$hasil_fantasy3 = $count3gr_fantasy/$total3gram;
								$hasil_mistery3 = $count3gr_mistery/$total3gram;
								print FILE "$num_ganjil:$hasil_fantasy3 $num_genap:$hasil_mistery3 ";
							}
							$num_ganjil+=2;
							$num_genap+=2;
						}
					}
				}print FILE"\n";
			}
                $count++;	
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
