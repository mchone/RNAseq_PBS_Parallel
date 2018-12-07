#!usr/bin/perl
my ($gff,$out)=@ARGV;
open GFF,"<$gff" or die ($!);
open OUT,">$out" or die ($!);

my %gtff;

my @gtf = `ls *.gtf2`;
for $spe(@gtf){
$id = (split(/_/,$spe))[0];
open SPE,"<$spe" or die ($!);
@exp=<SPE>;
chomp(@exp);
close SPE;
for $ele(@exp){
next if ($ele !~ /reference_id/);
if ((split(/\t/,$ele))[8] =~ /reference_id\s"(\S+)";.*TPM\s"(\S+)";/){
$gtff{$id}{$1} = $2;
}
}
}

print OUT ""."\t";
for $spe(@gtf){
print OUT (split(/_/,$spe))[0]."\t";
}
print OUT "\n";

while (<GFF>){
chomp;
#next if ($_=~/\tgene\t/);
if ($_ =~ /ID=(\S+);Name=/){
print OUT $1."\t";
for $spe(@gtf){
$tid = (split(/_/,$spe))[0];
if (exists $gtff{$tid}{$1}){
print OUT $gtff{$tid}{$1}."\t";
}
else {
print OUT "NA"."\t";
}
}
}
print OUT "\n";
}
close GFF;
close OUT;
