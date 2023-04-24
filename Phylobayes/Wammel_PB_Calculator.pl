use 5.014;
use warnings;

my $AAFile = $ARGV[0];
my $ABFile = $ARGV[1];
my $BAFile = $ARGV[2];
my $BBFile = $ARGV[3];

my @Values;

LnLCollector($AAFile, $ABFile, $BAFile, $BBFile);
my $AAAB = $Values[0]-$Values[1];
my $BBBA = $Values[2]-$Values[3];
my $Wammel = $AAAB - $BBBA;
print "AA vs. AB Bayes Factor\t", $AAAB, "\n";
print "BB vs. BA Bayes Factor\t", $BBBA, "\n";
print "Wammel Coherence\t", $Wammel, "\n";
sub LnLCollector{
foreach my $in (@_){
	open(IN, '<', $in) or die $!;
	my $LnL;
	my @Array;
	while (<IN>){
		if ($_ =~ / \d/){
	                my $line = $_;
    	            chomp($line);
        	        @Array = split(/\s+/, "$line");
            	    $LnL = $Array[3];
            	    push (@Values, $LnL);
                	}
	}
	}
return @Values;
}

#LnLCollector($AAFile, $ABFile);

#print @Values;

#print $AALnL;
