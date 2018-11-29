#!/bin/bash
#SNP-calling pipeline
#define usage function
programname=$0
usage(){
 echo "usage: $programname [-a file] [-b file] [-r file] [-oefzvih]"
 echo "a : Input reads file – pair 1"
 echo "b : Input reads file – pair 2"
 echo "r : Reference genome file"
 echo "o : Output VCF file name"
 echo "e : Perform reads re-alignment"
 echo "f : Mills file name"
 echo "z : Gunzip output VCF file (*.vcf.gz)"
 echo "v : Verbose; print each instruction/command to tell the user what your script is doing right now"
 echo "i : Index the output BAM file"
 echo "h : Print usage information"
 exit 1
}

# Initialize path to dependency file(s)
cd $(dirname $0)

# Initialize variables for command line arguments and default options
pair1=
pair2=
ref_geno=
vcf_file_name=output/output.vcf
reali=false
index_bam=false
gz_vcf=false


# Receiving command line argument and options
# Getting arguments from command line
# Some checks on the arguments/options; Alert user the usage if any required arguments missing
while getopts ":a:b:r:oefzvih" opt;
do
case $opt in
a) pair1=$OPTARG;;
b) pair2=$OPTARG;;
r) ref_geno=$OPTARG;;
o) vcf_file_name=$OPTARG;;
e) reali=true;;
f) Mills_file_name=$OPTARG;;
z) gz_vcf=true;;
v) set -x;;
i) index_bam=true;;
h) usage;;
esac
done

# Check for existence of files
[ ! -e $pari1 ] && echo "pair1 file missing" exit;
[ ! -e $pari2 ] && echo "pair2 file missing" exit;
[ ! -e $ref_geno ] && echo "reference genome file missing" exit;

# Pipeline begins
bwa index $ref_geno
bwa mem -M -R '@RG\tID:foo\tSM:bar\tLB:library1' $ref_geno $pair1 $pair2 > tmp/lane.sam
samtools fixmate -O bam tmp/lane.sam  tmp/lane_fixmate.bam
samtools sort -O bam -o tmp/sorted_reads.bam -T tmp/lane_temp tmp/lane_fixmate.bam
samtools index tmp/sorted_reads.bam

if [ "$reali" = true ]
then
java -jar lib/picard.jar CreateSequenceDictionary R= $ref_geno O= $ref_geno.dict
java -jar lib/GenomeAnalysisTK.jar -T RealignerTargetCreator -R $ref_geno -I tmp/sorted_reads.bam -o tmp/realignment_targets.list --known $Mills_file_name
java -jar lib/GenomeAnalysisTK.jar -T IndelRealigner -R $ref_geno -I tmp/sorted_reads.bam -targetIntervals tmp/realignment_targets.list -o tmp/realigned.bam
fi

if [ "$index_bam" = true ]
then
 samtools index tmp/realigned.bam
fi

if [ -e tmp/realigned.bam ]
then
  java -jar lib/GenomeAnalysisTK.jar -T HaplotypeCaller -R $ref_geno -I $index_read -o $vcf_file_name
else
  java -jar lib/GenomeAnalysisTK.jar -T HaplotypeCaller -R $ref_geno -I tmp/sorted_reads.bam -o $vcf_file_name
fi

if [ "$gz_vcf" = true ]
then
gzip $vcf_file_name
fi
