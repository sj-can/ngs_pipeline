# Command Line execution 
## BWA on the commandline

Once complete the following command will aligne the raw fastq files against the reference genome  

You need to edit the "detailed command format" on the command line by replacing all of the paths in brackets [] with the variable definitons below

*Detailed command format:*

   nohup [/path/to/bwa] mem -M -t 1 [/path/to/reference] -R “@RG\tID:[sample_name]\tSM[sample_name]” [/path/to/forward-fastq] [/path/to/reverse-fastq] > [path/to/output] &


*Varable definitions:*

    [/path/to/bwa] = /home/ec2-user/software/bwa/bwa  
    [/path/to/reference] = /home/ec2-user/course_data/resources/reference/human_g1k_v37.fasta  
    [sample_name] = sample_1  
    [/path/to/forward-fastq] = /home/ec2-user/NGS_pipeline/raw_data/v501_EX0000001_S17_R1_001.fastq.gz  
    [/path/to/reverse-fastq] = /home/ec2-user/NGS_pipeline/raw_data/v501_EX0000001_S17_R2_001.fastq.gz  
    [/path/to/output] = /home/ec2-user/NGS_pipeline/sample_1.sam  

This may take a few minutes to complete. You can see if the BWA program is still running by typing:

    jobs
