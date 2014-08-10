use v5.10;

# read into string;
open my $fh, '<', 'big.txt';
read $fh, my $buffer, -s $fh;
close $fh;


## to lower case and to array
my @words = split(/\W+/, lc($buffer));

## to hash
my %words_dic;
foreach (@words) {
    # only count the word are composed of a-z ( normal english word)
    $words_dic{$_}++ if /^[a-z]+$/;
}


## sort and write
open my $fh_out, '>', 'output_perl.txt';

foreach ( sort { $words_dic{$a} <=> $words_dic{$b} || $a cmp $b } ( keys %words_dic ) ) {
    say $fh_out "$words_dic{$_}, $_";
}

close $fh_out;
