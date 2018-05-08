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


Lets start with the configuration. Open it up to edit it. 
Add in the path to bwa executable (file)

bwa:
  /home/ec2-user/software/bwa

Now open up the snakefile

We know we need to include a bwamem rule so let us pre-emptively include that here:

include: "./bwamem"

and just like the other's we know we want that to be an easy to use variable so lets's add that in too.

bwa = config["bwa"]

Seeing as we are only interested in the alignment stage at the minute
Let's add in a rule all expand statement which tells the program we want to stop at the last part of the alignment processing:

expand("{workbatch}/assembly/{sample}.fixmate.rmdup.bam", workbatch=workbatch, sample=samples)

We also need to comment out the others so they are not run simultaneously. 

use # at the start of each of the other expand rules

Now we need to make sure the bwa mem rule file is available to use

add in the specified outputs to the correct sections:
	"{workbatch}/asembly/{sample}.sam"
	1
        "@RG\tID:{sample}\tSM:{sample}"
	"{workbatch}/logs/{sample}.log"
	forward = config["samples"][wildcards.sample][0],
        reverse = config["samples"][wildcards.sample][1]
        shell("{bwa} mem -M -t {threads} {fa} -R '{params}' {workbatch}/rawdata/{forward} {workbatch}/rawdata/{reverse} > {output} 2>{log})

start snakemake

$ nohup snakemake 2>&1 &
