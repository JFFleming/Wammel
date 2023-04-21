use 5.014;
use warnings;

print "Welcome to the Wammel Phylobayes Formatter. 
This script takes as input two txt files containing information about the two datasets you are interested in comparing, and formats them for a Wammel-style analysis.
In addition, it provides a txt file of example Phylobayes commands to move efficiently through the workflow.

The expected input file format is a list as follows:
FastaFile
Newick Tree containing original tree
Newick Tree with the topology produced by the analysis of the fasta in the input file, but using the taxa present in the comparative analysis
Model used by the analysis associated with the fasta file, in Phylobayes format (for example: -lg -ncat 4)
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
system ("cp $Alist[0] AA/");
system ("cp $Alist[0] AB");
system ("cp $Alist[1] AA");
system ("cp $Alist[2] BA");

open(FA, '<', $InfoFileB) or die $!;
my @Blist;
while (<FA>){
	my $line = $_;
	chomp($line);
	push(@Blist,$line);
}
system ("cp $Blist[0] BB");
system ("cp $Blist[0] BA");
system ("cp $Blist[1] BB");
system ("cp $Blist[2] AB");

my $outfile = 'phylobayesexamplecommands.txt';
open (OUT, '>', $outfile) or die $!;
print OUT "Welcome to the Wammel Guide File for Phylobayes. This file contains example commands to run your analyses. 
Please bear in mind that pb_mpi is an mpi program, and so these example commands may need to be added to an MPI script.
In addition, pb_mpi may be installed in a specific directory, which should be indicated prior to the pb_mpi command.

To establish the Initial Chain to obtain the Posterior Hyperprior, use these commands in the corresponding directories:
pb_mpi -d $Alist[0] $Alist[3] -T $Alist[1] -x 1 1100 -s AAChain
pb_mpi -d $Alist[0] $Alist[3] -T $Blist[2] -x 1 1100 -s ABChain
pb_mpi -d $Blist[0] $Blist[3] -T $Blist[1] -x 1 1100 -s BBChain
pb_mpi -d $Blist[0] $Blist[3] -T $Alist[2] -x 1 1100 -s BAChain

Use readpb_mpi to obtain the Posterior Hyperprior, like so:

readpb_mpi -x 100 1 -posthyper AAChain.posthyper
readpb_mpi -x 100 1 -posthyper ABChain.posthyper
readpb_mpi -x 100 1 -posthyper BBChain.posthyper
readpb_mpi -x 100 1 -posthyper BAChain.posthyper

To conduct the stepping stone analysis use these commands in the corresponding directories:
pb_mpi -d $Alist[0] $Alist[3] -f -T $Alist[1] -self_tuned_sis 1 10 30 0.1 200 -emp_ref AAChain.posthyper AA_SI_1
pb_mpi -d $Alist[0] $Alist[3] -f -T $Alist[1] -self_tuned_sis 1 10 30 0.1 200 -emp_ref AAChain.posthyper AA_SI_2
pb_mpi -d $Alist[0] $Alist[3] -f -T $Blist[2] -self_tuned_sis 1 10 30 0.1 200 -emp_ref ABChain.posthyper AB_SI_1
pb_mpi -d $Alist[0] $Alist[3] -f -T $Blist[2] -self_tuned_sis 1 10 30 0.1 200 -emp_ref ABChain.posthyper AB_SI_2
pb_mpi -d $Blist[0] $Blist[3] -f -T $Blist[1] -self_tuned_sis 1 10 30 0.1 200 -emp_ref BBChain.posthyper BB_SI_1
pb_mpi -d $Blist[0] $Blist[3] -f -T $Blist[1] -self_tuned_sis 1 10 30 0.1 200 -emp_ref BBChain.posthyper BB_SI_2
pb_mpi -d $Blist[0] $Blist[3] -f -T $Alist[2] -self_tuned_sis 1 10 30 0.1 200 -emp_ref BAChain.posthyper BA_SI_1
pb_mpi -d $Blist[0] $Blist[3] -f -T $Alist[2] -self_tuned_sis 1 10 30 0.1 200 -emp_ref BAChain.posthyper BA_SI_2

Once you have a reaosnably long stepping stone chain with good effective sample size, you can obtain the marginal likelihood using this script, contained in the pb_mpi package:

python3 scripts/read_marglikelihood.py AA_SI_?.stepping > AA.marginal
python3 scripts/read_marglikelihood.py AB_SI_?.stepping > AB.marginal
python3 scripts/read_marglikelihood.py BB_SI_?.stepping > BB.marginal
python3 scripts/read_marglikelihood.py BA_SI_?.stepping > BA.marginal

Finally, use the WammelCalculator.pl script contained here to calculate the Wammel Score (Bayesian Coherence)

WammelCalculator.pl AA/AA.marginal AB/AB.marginal BB/BB.marginal BA/BA.marginal

";
