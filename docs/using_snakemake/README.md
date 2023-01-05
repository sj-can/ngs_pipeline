# Using snakemake with our data

## Our important files - overview

### Config.yaml file
  * Sets batch specific variables such as the workbatch directory
  * Samples in the batch are specified here

### Snakefile
  * Contains the rule files to include
  * Provides succinct names to the config variables
  * Specifies the all rules to expand

### Rule files
  * Rules specify the process specific variables required to knit all processes together
  * Seaprate files enable rules to be neatly separated which is useful for readability and troubleshooting

## Getting stuck in with bwa
**Remember**
  * Inputs need to link to outputs
  * Endpoints need to be specified in the snakefile rule all

The following steps need to be configured to add a rule to the pipeline. We are going to use the bwa command, which you previously used on the command line as an example. It is already partially completed.

Lets start with the **configuration file** (config.yaml). Change to it's directory and open it up to edit it.

    cd /home/ubuntu/hpdm098/workshops/ngs_pipeline/snakefiles

Add in the path to bwa executable (file)

    bwa:
        /usr/bin/bwa

Now open up the **Snakefile**

We know we need to include a bwamem rule so let us pre-emptively include that here:  

    include: "./bwamem"

and just like the others we know we want the bwa path to be an easy to use variable so lets's add that in too.

    bwa = config["bwa"]

Seeing as we are only interested in the alignment stage at the minute, let's add in a rule all
expand statement which tells the program we want to stop at the last part of the alignment processing:

    expand("{workbatch}/assembly/{sample}.fixmate.rmdup.bam", workbatch=workbatch, sample=samples)

We also need to comment out the others so they are not run simultaneously. 

    use # at the start of each of the other expand rules to comment them out

Now we need to make sure the **bwamem** rule file is available to use.

Add the outputs specified below to the correct sections  

     "{workbatch}/asembly/{sample}.sam"  

     1  

     "@RG\\tID:{sample}\\tSM:{sample}"  

     "{workbatch}/logs/{sample}.log"  

     forward = config["samples"][wildcards.sample][0],  

     reverse = config["samples"][wildcards.sample][1]  

     shell("{bwa} mem -M -t {threads} {fa} -R '{params}' {workbatch}/rawdata/{forward} {workbatch}/rawdata/{reverse} > {output} 2>{log})  

start the snakemake pipeline  

    nohup snakemake --cores 1 2>&1 &

Then press enter

## Variant Calling

Your challenge is to adjust the pipeline code, using steps similar to above, and add in the GATK variant caller stage.  

Ultimately, You will need to:

Study this command and integrate it into the pipeline.  

    [/path/to/java] -Xmx4g -jar [/path/to/gatk] -T HaplotypeCaller -R [/path/to/reference] -L [/variant/calling/intervals] -I {input} -o {output.vcf} 2>> path/to/log/file"

To do this you need to decide where to specify all of the required paths within the:
1. config file
2. Snakefile
3. rule file

**HINTS**:
1. All of the software and interval files you need is already on the system
3. Any variables you add to the config file need to be added to the Snakefile as well
4. The snakefile needs to know which rules to include
5. The outputs of one rule are the inputs of the next rule
6. Check the command is correct
7. Test with snakemake -np
8. If nothing is happening, try changing the Snakefile endpoint i.e. what file do we want to end up with?
8. Run with nohup snakemake --cores 2>&1 &

**MEGAHINTS**  

Open up the config file  

Is java in there?  
Is gatk in there? 

Input and output aren't in here but they're specified in the rule file, so we'll come back to those

Now lets have a look at the Snakefile

Include the haplotypecaller rule file in the Snakefile
    
    include: "./haplotypecaller"

Add any config variables to the Snakefile e.g. gatk software

    gatk = config["gatk"]
    
    variant_calling_intervals = config["variant_calling_intervals:"]    

At some point we need to adjust the all rule expand statement to include the changes we have juat made as the pipeline endpoint. 
To do this we need to know what the last output file we want is and we haven't decided on that yet so we'll do that and come back to the snakefile.
Go to the gatk haplotyper rule file to decide on the inputs and outputs.

Now complete the empty shell command following the format previously specified but replacing variables with any we have previously defined or as they exist on the system. 
The first one is done for you. 

So now we've got the command we want to run we need to tell snakemake that we want it to run it. So back to the snake file. Make sure we remember the output file we want:  

     expand("{workbatch}/variants/{sample}_unfiltered.vcf", workbatch=workbatch, sample=samples)
