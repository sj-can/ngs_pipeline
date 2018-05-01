#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

library("ExomeDepth")
library("GenomicRanges")

load("/home/ec2-user/course_data/resources/exome_depth/v501_exons.RData")
load("/home/ec2-user/course_data/resources/exome_depth/v501_controls.RData")

panel.version <- "v501"

dir.base <- args[1]
dir.results <- sprintf("%s/variants", dir.base)

v501_exons.GRanges <- GRanges(seqnames = v501_exons$chromosome,
                              IRanges(start=v501_exons$start,end=v501_exons$end),
                              names = v501_exons$name)
                              
alignment.folder <- sprintf("%s/assembly", dir.base)

setwd(alignment.folder)
print(alignment.folder)

bed <- '/home/ec2-user/course_data/resources/exome_depth/v501_CNV_121.bed'
reference.fasta <- '/home/ec2-user/course_data/resources/reference/human_g1k_v37.fasta'

#get list of sample BAM files
bams.positive <- paste(args[2],'.fixmate.rmdup.bam', sep='')
bais.positive <- paste(args[2],'.fixmate.rmdup.bai', sep='')


FemaleExomeCounts.mat <- as.matrix(FemaleExomeCount.mat[, grep(names(FemaleExomeCount.mat), pattern = '*.bam')])

bams.selected <- c(bams.positive)
bais.selected <- c(bais.positive)

# Create counts dataframe for all BAMs
my.counts <- getBamCounts(bed.file = bed, bam.files = bams.selected, index.files = bais.selected, min.mapq = 20, include.chr = FALSE, referenceFasta = reference.fasta)
ExomeCount.dafr <- as(my.counts[, colnames(my.counts)], 'data.frame')
ExomeCount.dafr$chromosome <- gsub(as.character(ExomeCount.dafr$space),pattern = 'chr',replacement = '')
	
# Create matrix
ExomeCount.mat <- as.matrix(ExomeCount.dafr[, grep(names(ExomeCount.dafr), pattern = '*.bam')])
	
nsamples <- ncol(ExomeCount.mat)
samplenames <- colnames(ExomeCount.dafr)
	
dir.output <- file.path(dir.base)

#save.image( sprintf("%s/female_exome_depth_count.RData", dir.output) )

for (i in 1:nsamples) {
  
          samplename <- samplenames[i + 6]
   
            print(samplename)
  #### Create the aggregate reference set for this sample
            my.choice <- select.reference.set (test.counts = ExomeCount.mat[,i],
                                     reference.counts = FemaleExomeCounts.mat,
                                     bin.length = (ExomeCount.dafr$end - ExomeCount.dafr$start)/1000,
                                     n.bins.reduced = 10000)
            my.reference.selected <- apply(X = FemaleExomeCounts.mat[, my.choice$reference.choice, drop = FALSE],
                                 MAR = 1,
                                 FUN = sum)
            message('Now creating the ExomeDepth object')
            all.exons <- new('ExomeDepth',
                   test = ExomeCount.mat[,i],
                   reference = my.reference.selected,
                   formula = 'cbind(test, reference) ~ 1')
           print(my.choice$reference.choice)
  ################ Now call the CNVs
            all.exons <- CallCNVs(x = all.exons,
                        transition.probability = 10^-4,
                        chromosome = ExomeCount.dafr$chromosome,
                        start = ExomeCount.dafr$start,
                        end = ExomeCount.dafr$end,
                        name = ExomeCount.dafr$names)
            if (nrow(all.exons@CNV.calls) > 0) {
	    	          all.exons <- AnnotateExtra(x = all.exons,
                               reference.annotation = v501_exons.GRanges,
                               min.overlap = 0.0001,
                               column.name = 'v501_exons')

  
                  output.file <- paste(dir.results, '/', args[2], '_exomedepth.csv', sep = '')
                  write.csv(file = output.file, x = all.exons@CNV.calls, row.names = FALSE)
            }
}
