#!/usr/bin/perl
# Digunakan untuk membangkitkan kamus sebanyak n-gram
#
# Taufik Fuadi Abidin
# Mei 2011
#
# Modified by Yuda Aditya
# NIM 1608107010030
# Informatics, Syiah Kuala University
# Date: March 2019


use lib '../lib';
use Lingua::EN::Bigram;
use strict;
use Lingua::Stem::Snowball;

my %stopwords;

load_stopwords(\%stopwords);

# my @datas = ("samsung","apple");
my @datas = ("hasil");
# my @datas = ("fantasy","fiction","mistery");

foreach my $data (@datas) {

	my %kata;

	my $files = `ls -v $data/`;

	my @listFile = split('\n',$files);

	my $nberapa = $ARGV[0];

	open OUT, "> kamus/$nberapa-gram-data-$data.txt"  or die "File tidak dapat dibuka/dibuat...";

	my %hashKata;


	foreach my $isidir (@listFile) {
		my $file = "$data/$isidir";

		open F, $file or die "Can't open input: $!\n";
		my $texts = do { local $/; <F> };
		close F;

		my $text = content($texts);

		
			# build n-grams
			my $ngrams = Lingua::EN::Bigram->new;
			$ngrams->text( $text );

			my @inputgrams = $ngrams->ngram( $nberapa );

			# get n-grams counts
			my $bigram_count = $ngrams->ngram_count( \@inputgrams );;

			# my $index = 0;
			

			#print "##Bi-grams (T-Score, count, bi-gram)\n";
			#foreach my $bigram ( sort { $$tscore{ $b } <=> $$tscore{ $a } } keys %$tscore ) {
			foreach my $bigram (sort{$$bigram_count{$b} <=> $$bigram_count{$a} } keys %$bigram_count ) {

				if( $ARGV[0] == 1 ){
					# get the tokens of the bigram
					my $first_token = $bigram;
					# skip stopwords and punctuation
					next if ( $first_token eq '' );
					next if ( $stopwords{ $first_token } );
					next if ( $first_token =~ /[,.?!:;()\-'']/g );

				}elsif( $ARGV[0] == 2 ){
					# get the tokens of the bigram
					my ( $first_token, $second_token ) = split / /, $bigram;
					# skip stopwords and punctuation
					next if ( $first_token eq '' );
					next if ( $stopwords{ $first_token } );
					next if ( $first_token =~ /[,.?!:;()\-'']/g );

					next if ( $second_token eq '' );
					next if ( $stopwords{ $second_token } );
					next if ( $second_token =~ /[,.?!:;()\-'']/g );

				}elsif( $ARGV[0] == 3 ){
					# get the tokens of the bigram
					my ( $first_token, $second_token, $third_token ) = split / /, $bigram;
					# skip stopwords and punctuation
					next if ( $first_token eq '' );
					next if ( $stopwords{ $first_token } );
					next if ( $first_token =~ /[,.?!:;()\-'']/g );

					next if ( $second_token eq '' );
					next if ( $stopwords{ $second_token } );
					next if ( $second_token =~ /[,.?!:;()\-'']/g );

					next if ( $third_token eq '' );
					next if ( $stopwords{ $third_token } );
					next if ( $third_token =~ /[,.?!:;()\-'']/g );

				}else{
					die "Hanya Masukan 1, 2 atau 3..."; # pembatasan input agar tidak melebihi 3 gram, berupa opsional
				}
					# pengecekan duplikasi kata
				if ($hashKata{$bigram}) {
					$hashKata{$bigram}+=$$bigram_count{$bigram};
				} else {
					$hashKata{$bigram}=$$bigram_count{$bigram};
				}
				# $index++;
				# print OUT "$$bigram_count{ $bigram }\t$bigram\n";
			}
	}
	foreach my $kata (keys %hashKata){
		print OUT "$hashKata{$kata}\t$kata\n";
	}
	close OUT;
}

sub load_stopwords
{
  my $hashref = shift;
  open IN, "< stopwords-en.txt" or die "harap masukan file stopword";
  while (<IN>)
  {
    chomp;
    if(!defined $$hashref{$_})
    {
       $$hashref{$_} = 1;
    }
  }
}
# membersihkan content dari tag2 yang ada
sub content {
	my $tulisan = $_[0];
	my ($judul, $atas, $tengah1,$tengah2, $bawah);
	if ($tulisan =~ /<title>([\s\S]*)<\/title>/) {
		$judul=$1;
	}
	if ($tulisan =~ /<atas>([\s\S]*)<\/atas>/) {
		$atas=$1;
	}
	if ($tulisan =~ /<tengah1>([\s\S]*)<\/tengah1>/) {
		$tengah1=$1;
	}
	if ($tulisan =~ /<tengah2>([\s\S]*)<\/tengah2>/) {
		$tengah2=$1;
	}
	if ($tulisan =~ /<bawah>([\s\S]*)<\/bawah>/) {
		$bawah=$1;
	}

	my $content = "$judul\n\n$atas\n\n$tengah1\n\n$tengah2\n\n$bawah\n\n";
	return $content;
}
