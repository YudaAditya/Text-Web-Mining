use warnings;
use strict;
use WWW::Mechanize;


my $folder= $ARGV[0] or die "Harap masukan folder yang menjadi tempat menyimpan hasil Crawl !!!";
# my $folder = "/home/yuda/Downloads/TWM/Tugas 1/Samsung/hasil_kompas";

my $mech = WWW::Mechanize->new();
$mech->agent_alias('Windows Mozilla'); #user agent untuk tanda pengenal
my $tanggal = 8;
my $bulan = 3;
my $tahun = 2019;

my $detikReg = "/book/show/";

# my $keyword = "samsung";
# my $keyword2="galaxy";
# my $keyword = "apple";
# my $keyword2 = "iphone";
# my $keyword3 = "macbook";
# my $keyword4 = "watch";
# my $keyword5 ="ipad";
# my $keyword6 = "ios";
# my $keyword7 ="macos";fantasy

my $pages = 100; #batas page dari portal
my $count=1; #hitung page sampain limit

my $web ="https://www.periplus.com/c/1_32_347/science-fiction?page=";
my $source = "fiction";
# my $reg = "/book/show/";
my $fileout = $ARGV[0] or die "Harap masukan nama yang menjadi tempat menyimpan hasil Link !!!";
# open OUT, "> $fileout" or die "Cannot Open File!!!";

#fungsi buat crawlingSS
sub webCrawl{
  $mech->get($_[0]);
  my @links = $mech->links();
  my %urls; 

      foreach my $link (@links) {
        my $url = $link->url;
        if ($url=~ /\/p\/\d*/g) {#REGEX Diantara //
            # if($url =~ $keyword || $keyword2 || $keyword3 || $keyword4 || $keyword5 || $keyword6 ||$keyword7){
            # if($url =~ /show/ ){
              $urls{$url}=1; #untuk setiap value dari hash bernilai 1 dengan link sebagai id
            # }
        }


      }
      my $i= $_[1]; 
      foreach my $url (keys %urls) {
          # system "wget -O $folder/$source-$i-$count.html https://www.goodreads.com/$url";
          system "wget -O $folder/$source-$i-$count.html $url";
          # print OUT "$url\n";
          # system "wget -O $folder/$source-$keyword-$i.html $url";
        $i++;
      }
      return $i;
}

# perulangan pada tanggal bulan tahun
# my $total=0;
# while ($total<=2000) { #batas dari file yang ingin di crawl
#  $total = webCrawl("$web/$tahun/0$bulan/0$tanggal",$total);# parameter yang dikirim kedalam function
#  $tanggal--;
#  if ($tanggal==0) {
#    $bulan--;
#     if ($bulan==0) {
#       $bulan=12;
#       $tahun--;
#     }
#    $tanggal=27;
#  }

# }


my $total;
  for ($total=1 ; $total <=10000 ; $count++) {
    $total = webCrawl("$web=$count&limit=100",$total);
    if ($count==$pages) {
      last;
    }
  }