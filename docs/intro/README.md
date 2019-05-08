# Introduction 

## Useful documentation and definitions

Below are links to the documentation for the software used in this workshop as well as useful definitions.  

### Documentation and useful definitions

_Tool Documentation_  
[Burrows-Wheeler Aligner (BWA)](http://bio-bwa.sourceforge.net/bwa.shtml "BWA manual page")  
[Alamut batch](http://www.interactive-biosoftware.com/doc/alamut-batch/Alamut-Batch-1.5.0-User-Manual.pdf "Alamut Batch manual")  
[Samtools](http://www.htslib.org/doc/samtools.html "Samtools manual")  
[Picard](https://broadinstitute.github.io/picard/command-line-overview.html "Picard manual")  
[Genome Analysis Toolkit (GATK)](https://software.broadinstitute.org/gatk/documentation/tooldocs/current/ "GATK doc pages")  
[ExomeDepth](https://academic.oup.com/bib/article/16/3/380/245577 "ExomeDepth paper") 
[Snakemake](http://snakemake.readthedocs.io/en/stable/tutorial/tutorial.html "Snakemake tutorial")  
  
_Useful Documentation_  
[ACMG variant classification guidelines](http://www.acgs.uk.com/media/1092626/uk_practice_guidelines_for_variant_classification_2017.pdf "Variant classifaction guidelines")

_Useful definitions_  
[SAM/BAM format](https://samtools.github.io/hts-specs/SAMv1.pdf "SAM/BAM format")  
[VCF format](https://samtools.github.io/hts-specs/VCFv4.2.pdf "Variant call format")  
[FASTA format](https://zhanglab.ccmb.med.umich.edu/FASTA/ "FASTA format")  
[FASTQ format](https://genome.ucsc.edu/FAQ/FAQformat.html#format1 "FASTQ format")  
[Read groups](http://gatkforums.broadinstitute.org/gatk/discussion/6472/read-groups "Read Groups")  
[BED format](https://genome.ucsc.edu/FAQ/FAQformat.html#format1 "BED format")  
[Interval file formats](http://www.broadinstitute.org/gatk/guide/article?id=1319 "Interval File formats")
 
### Getting started

**_Remember:_**
  * For this course, information between [] such as [/path/to/file] needs to be altered for the command to work. Do not include the [] symbols if they previously surrounded a command line argument which needed altering. 
  
  * When learning it is beneficial to type the commands rather than copy and paste them. 

#### Exploring the directories and files

To start with, use the print working directory command to check you are in the location '/home/ec2-user' or equivalent:

    pwd

If you are not, change directories using the below command:

    cd /home/ubuntu

Now take five minutes to get used to the file system and file contents using commands such as:  

    ls <path>

To view the files directory names

   cd <path>

To change directory 

    less <path>

To view and edit the contents of a file

    nano <path>

**_Remember:_** Do not use nano on large files as it will use up all the memory and freeze your machine.

Used the below command to view files and directories three levels deep from your current location

	tree -L 3

Try to find the location of this file:

    v501_EX0000001_S17_R1_001.fastq.gz

The extention .gz indicates it has been compressed uing the gzip program.  
You can find out about the gzip program by tying the below to look at it's documentation or manual page

    man gzip

Most linux distribution tools such as less, more, head, tail, nano also have manual pages.  
Because it is compressed you can use this to view the top four lines after changing to the raw data directory:  

    gzip -cd v501_EX0000001_S17_R1_001.fastq.gz | head -n 4

Once complete alert a facilitator and await instruction.
