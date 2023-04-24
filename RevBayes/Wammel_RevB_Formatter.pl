use 5.014;
use warnings;

print "Welcome to the Wammel Revbayes Formatter. 
This script takes as input two txt files containing information about the two datasets you are interested in comparing, and formats them for a Wammel-style analysis.
It outputs four Revbayes scripts into sorted directories to allow you to undertake your analysis, and also crafts a simple Revbayes script to calculate 
	the Wammel Coherence Index once the analysis has finished.

The expected input file format is a list as follows:
FastaFile
A file containing a series of constraints, in the RevBayes format, corresponding to the topology initially produced by the analysis of the fasta file, 
	under the model (for examples, please see the provided example file). The final constraint must always be named TotalClade.
A file containing the model used by the analysis associated with the fasta file, in Revbayes format (for examples, please see the provided Models folder)
";

my $InfoFileA = $ARGV[0];
my $InfoFileB = $ARGV[1];

system ("mkdir AA AB BA BB");

open(FA, '<', $InfoFileA) or die $!;
my @Alist;
while (<FA>){
	my $line = $_;
	chomp($line);
	push(@Alist,$line);
}

open(FA, '<', $InfoFileB) or die $!;
my @Blist;
while (<FA>){
	my $line = $_;
	chomp($line);
	push(@Blist,$line);
}

system ("cp $Alist[0] AA");
system ("cp $Alist[0] AB");
system ("cp $Blist[0] BB");
system ("cp $Blist[0] BA");

system ("sed -e 's/<GROUP>/AA/g' -e 's/<FASTAFILE>/$Alist[0]/g' -e '/CLADECONSTRAINTS ####/r $Alist[1]' -e '/MODELFILE ####/r $Alist[2]' RevBayesTemplate.rev > GroupAA.rev");
system ("sed -e 's/<GROUP>/BA/g' -e 's/<FASTAFILE>/$Blist[0]/g' -e '/CLADECONSTRAINTS ####/r $Alist[1]' -e '/MODELFILE ####/r $Blist[2]' RevBayesTemplate.rev > GroupBA.rev");
system ("sed -e 's/<GROUP>/AB/g' -e 's/<FASTAFILE>/$Alist[0]/g' -e '/CLADECONSTRAINTS ####/r $Blist[1]' -e '/MODELFILE ####/r $Alist[2]' RevBayesTemplate.rev > GroupAB.rev");
system ("sed -e 's/<GROUP>/BB/g' -e 's/<FASTAFILE>/$Blist[0]/g' -e '/CLADECONSTRAINTS ####/r $Blist[1]' -e '/MODELFILE ####/r $Blist[2]' RevBayesTemplate.rev > GroupBB.rev");

system ("sed -e 's/<AA>/AA_output\\/pow_p_noclock\.$Alist[0]\.AA.out/g' -e 's/<AB>/AB_output\\/pow_p_noclock\.$Alist[0]\.AB.out/g' -e 's/<BB>/BB_output\\/pow_p_noclock\.$Blist[0]\.BB.out/g' -e 's/<BA>/BA_output\\/pow_p_noclock\.$Blist[0]\.BA.out/g' RevBayesCalculator_Template.rev > Personalised_RevBayes_WammelCalculator.rev");
