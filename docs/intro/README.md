## Introduction 

### Useful documentation and definitions

Below are links to the documentation for the software used in this workshop as well as useful definitions.

Documentation and useful definitions
Tool Documentation
BWA - http://bio-bwa.sourceforge.net/bwa.shtml
Alamut batch - 
samtools
picard
gatk
exomedepth
snakemake

Useful Documentation
ACMG variant interpretation guidelines https://www.acmg.net/docs/standards_guidelines_for_the_interpretation_of_sequence_variants.pdf

Useful definitions
SAM/BAM format - https://samtools.github.io/hts-specs/SAMv1.pdf
VCF format - https://samtools.github.io/hts-specs/VCFv4.2.pdf 
FASTA format - http://zhanglab.ccmb.med.umich.edu/FASTA/
FASTQ format - https://genome.ucsc.edu/FAQ/FAQformat.html#format1
Read groups - http://gatkforums.broadinstitute.org/gatk/discussion/6472/read-groups
BED format – https://genome.ucsc.edu/FAQ/FAQformat.html#format1
Interval files - http://www.broadinstitute.org/gatk/guide/article?id=1319
 
### Getting started

The following convention applies to these docs:

anything between < > such as </path/to/file> indicates you need to alter the information between the two <> symbols as part of a command.  
You do not need to include the <> in the final command.

When learning it is beneficial to type the commands rather than copy and paste them as this is more likely to help you learn. 

#### Exploring the directories and files

To start with use the print working directory command to check you are in the location '/home/ec2-user' or equivalent

    pwd

If you are not use the below command to change directory

    cd /home/ec2-user

Now, get used to exploring the file system and file contents using commands such as:  

    ls <path>

To view the files directory names

   cd <path>

To change directory 

    less <path>

To view the contents of a file

    nano <path>

To view and edit the contents of a file.

Try to find the location of this file:

    v501_EX0000001_S17_R1_001.fastq.gz

The extention .gz indicates it has been compressed uing the gzip program.  
You can find out about the gzip program by tying the below to look at it's documentation or manual page

    man gzip

Most linux distribution tools such as less, more, head, tail, nano also have manual pages.

Because it is compressed you can use this to view the top four lines after changing to the raw data directory:

	$ gzip -cd v501_EX0000001_S17_R1_001.fastq.gz | head -n 4
