#**Snakemake targeted NGS data analysis pipeline **

Created by Andy Parrish, modified by Stuart Cannon

This analysis pipeline is designed to align fastq files to a reference genome and produce SNV/indel/CNV variant calls over targeted intervals using the Snakemake workflow management system. The steps undertaken are described in the snakefiles subfolder, and are chained together as follows:

![alt tag](https://raw.githubusercontent.com/AParrish1982/NGS_pipeline/master/workflow.png)

##Usage

###**1. Setup virtual environment:**

        /usr/local/bin/pyvenv-3.5 NGS_pipeline

###**2. Activate virtual environment:**

        source NGS_pipeline/bin/activate

###**3. Install Snakemake library using pip:**

        pip install snakemake

###**4. Clone pipeline Github repository:**

        git clone https://github.com/AParrish1982/NGS_pipeline.git    

###**5. Copy samples.csv file to workbatch/snakefiles folder:** 

###**6. Edit snakefiles/config.yaml:**

	Enter workbatch path, ftp path, flowcell, and HGMD Professional username/password combination

###**7. Run prep_config.py to download fastq files and copy sample information to config.yaml file:**

        python prep_config.py

###**8. Run snakemake command:**

        nohup snakemake -k --cores 16 2>&1 &

###**9. Deactivate virtual environment:**

        deactivate

