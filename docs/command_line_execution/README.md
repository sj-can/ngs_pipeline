# Command Line execution 
## BWA on the commandline

Once complete the following command will aligne the raw fastq files against the reference genome  

You need to edit the "detailed command format" on the command line by replacing all of the paths in brackets [] with the variable definitons below

**Detailed command format:**

    nohup [/path/to/bwa] mem -M -t1 [/path/to/reference] -R “@RG\tID:[sample_name]\tSM[sample_name]” [/path/to/forward-fastq] [/path/to/reverse-fastq] > [path/to/output] &  

**Variable definitions:**

    [/path/to/bwa] = /home/ubuntu/software/bwa/bwa  
    [/path/to/reference] = /home/ubuntu/course_data/resources/reference/human_g1k_v37.fasta  
    [sample_name] = sample_1  
    [/path/to/forward-fastq] = /home/ubuntu/NGS_pipeline/raw_data/v501_EX0000001_S17_R1_001.fastq.gz  
    [/path/to/reverse-fastq] = /home/ubuntu/NGS_pipeline/raw_data/v501_EX0000001_S17_R2_001.fastq.gz  
    [/path/to/output] = /home/ubuntu/NGS_pipeline/sample_1.sam  

This may take a few minutes to complete. You can see if the BWA program is still running by typing:

    jobs

Whlie you are waiting you can start work on the below challenge!

## SAM to BAM command line challenge

**Aims**  
Study the docs for picard tool suite and run a sam-bam conversion on the command line 

**Objectives**  
1. Follow the link to the [picard tools documentation](https://broadinstitute.github.io/picard/command-line-overview.html "Picard tools overview")
2. Read the “command syntax” and “usage example” sections at the top of the docs to determine the basic command line useage format
3. Find the instructions for the SamFormatConverter tool
4. Considering the command syntax and useage example information you have just read, type the commands into the command line to convert your SAM file into a BAM file

**Hint** -  
Think about what files you need and where they might be (you just made one of them and you have to specify the other)  
You cannot run this command until the previous one has completed  
**MegaHint** -  
picard.jar is a type of software  
