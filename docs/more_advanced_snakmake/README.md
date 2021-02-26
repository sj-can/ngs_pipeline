# Filtering variants

### Add in the next step of the pipeline to filter the vairants called by HaplotypeCaller

Study the command here and fill in the paths to the correct files to make it work  

    [path/to/java] -Xmx4g -jar [path/to/gatk] -T VariantFiltration -R [path/to/reference] --filterExpression 'QD < 2.0' --filterExpression 'MQ < 40.0' --filterName 'MQ40' 

    --filterExpression 'ReadPosRankSum < -8.0' --filterName 'RPRS-8' --filterExpression 'FS > 60.0' --filterName 'FS60'
    
    --filterExpression 'MQRankSum < -12.5' --filterName 'MQRankSum-12.5' -o [/path/to/output] --variant [/path/to/input] 2>>{log}"

### Hints

  * Check all of the paths you may want to include are in the config file (input and output go into the rule files)
  * Now look at the Snakefile and include the "filtervariants" file
  * Now go to the filtervariants rule file
  * Add the outputs of the last command as the inputs of this one
  * Add the path to the output file
  * Edit the shell command following the format specified above but replacing paths with the variables you have specified. Put everythng between the empty quotations. 
  * Use single quotations for anything requiring quotations in between the double quotations.
  * Finally, edit the expansion rule in the Snakefile using the output file you have decided on.

# Generating quality Metrics (FASTQC)
The time has come, you've made it this far so now its time to add in a whole rule from scratch. We are going to download FastQC, a program used to generate quality metrics from fastq files, and make it work as part of our pipeline.  

  * Go to the [FASTQC website](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
  * Click on download now  

Take note that there are usually some dependencies to be met (java and picard in this case)  
There are also usually [installation instructions](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/INSTALL.txt)

  * Right click on the FastQC v0.11.5 (Win/Linuz Zip file) and select 'copy link address'

Now move to your 'software' directory (don't forget where you are now!)

    cd /home/ubuntu/hpdm098/course_data/software

Download the FastQC with the command wget.

    wget [insert link to fastqc download]

You type wget and then paste the copied link from the fastQC webstie by right clicking

The downloaded file is a zipped file. To unzip it use:

    unzip [name of zip file]

  * Change into the unzipped folder.

Change the permissions so you can run it:

    chmod 775 [name of fastqc executable]

#### Congratulations! 

You have just downloaded some software. Now we need to set up the pipeline to use it effectively.

  * Add the path to fastqc to the **config** file
  * Now go to the **Snakefile**

We know we're going to need a fastqc rule so we can include that just like the rest of the rule files. 
We've just added a new config variable for fastqc path so we'll also specify that just like the rest. 

We know we'll need an expansion rule but let's add that in as the last step. First, we'll make a rule file for fastqc.
To do this it makes sense to run the command on the command line first to figure out how you want it to run.
I've done that alreaady and this is the suitable command:

    [path/to/fastqc/] -o [path/to/output/directory/] {input} 2>{log}"

So, open a new file with

    nano fastqc

Add the following to this file. Try to consider what each step is doing

    rule fastqc:
        input:
            "/home/ubuntu/hpdm098/workshops/ngs_pipeline/rawdata/{file}.fastq.gz"
        output:
            "/home/ubuntu/hpdm098/workshops/ngs_pipeline/metrics/fastQC/{file}_fastqc.zip",
        log:
            "/home/ubuntu/hpdm098/workshops/ngs_pipeline/logs/fastqc.log"
        shell:
            "{fastqc} -o /home/ubuntu/hpdm098/workshops/ngs_pipeline/metrics/fastQC/ {input} 2>{log}"

This example is actually little different to what we have been doing before. Previously we were doing one operation per sample everytime. 
For this example, we need to do two operations for each sample and each operation can be done independantly of the other.
So, to execute this command in the most effective manner, we should create an expansion rule that can be applied to every fastq file irrespective of sample ID.

To do this we need to gather the paths to each of these files. The following code does this and shold be palced in the Snakefile before the "rule all:" statments.

    import glob, ntpath
    
    inFiles = set()
    inPaths = glob.glob( "/home/ubuntu/hpdm098/workshops/ngs_pipeline/rawdata/*.fastq.gz")
    for p in inPaths:
        inFiles.add(os.path.basename(p).replace(".fastq.gz", ""))

Each line of this code does the following, respectively:
  * Sets in python only allow unique entries so we cannot call the program on the same file twice
  * Glob matches everything in this path that ends in "fastq.gz"
  * For loops iterate through all of the inPath matches we have found
  * We add each one to the inFile set variable and remove the fastq.gz extension


Then a suitable expand rule would be:

    expand("{workbatch}/metrics/fastQC/{filename}_fastqc.zip", workbatch=workbatch, filename=inFiles)

This expand statement runs the rule with "{workbatch}/metrics/fastQC/{filename}_fastqc.zip" for every {filename} in the inFiles variable.



