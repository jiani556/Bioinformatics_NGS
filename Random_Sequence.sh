#!/bin/bash

# Generate random DNA sequences into a user selected number of files
# This script generates random sequences in multi-fasta format.
# This script takes required flags '-n [INT] -m [INT]', where [INT] is any positive integer.
# This script also takes optional flag -v for verbose output"

num=""
seq=""
verbose=""

#################################
# Taking in commandline arguments
while getopts "n:m:v" opt; do
case $opt in
n)	num=$OPTARG;;
m)	seq=$OPTARG;;
v)	set -x;;
\?) echo "Invalid option: -$OPTARG";;
esac
done
for i in `eval echo {1..$num}`
do
touch seq${i}.fasta
for e in `eval echo {1..$seq}`
do
echo ">seq${i}_${e}">>seq${i}.fasta
done
done#...
################################


#################################
# 1. Check if the output files already exists. Delete if yes.
# 2. Generate output and write to files
#!/bin/sh
for i in {1..10}
do
touch seq${i}.fasta
if  [ $i -lt 4 ]
then
file="seq${i}.fasta"
[ -e $file ] && rm -f $file
echo ">seq${i} for seq${i}.fasta" >seq${i}.fasta
seq="$( cat /dev/urandom | LC_CTYPE=C tr -dc 'ACGT' | fold -w 50 | head )"
echo "$seq" >> seq${i}.fasta
fi
done
################################
