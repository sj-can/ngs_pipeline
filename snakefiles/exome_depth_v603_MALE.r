#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

library("ExomeDepth")
library("GenomicRanges")

load("/mnt/data1/targeted_sequencing/ExomeDepthFiles/v603/v603_exons.RData")
load("/mnt/data1/targeted_sequencing/ExomeDepthFiles/v603/v603_controls.RData")

panel.version <- "v603"

dir.base <- args[1]
dir.results <- sprintf("%s/variants", dir.base)

v603_exons.GRanges <- GRanges(seqnames = v603_exons$chromosome,
                              IRanges(start=v603_exons$start,end=v603_exons$end),
                              names = v603_exons$name)
                              
alignment.folder <- sprintf("%s/assembly", dir.base)

setwd(alignment.folder)
print(alignment.folder)

bed <- '/mnt/data1/targeted_sequencing/ExomeDepthFiles/v603/v603_CNV_120.bed'
reference.fasta <- '/mnt/data1/resources/human_g1k_v37.fasta'

#get list of sample BAM files
bams.positive <- paste(args[2],'.realigned.bam', sep='')
bais.positive <- paste(args[2],'.realigned.bai', sep='')


MaleExomeCounts.mat <- as.matrix(MaleExomeCount.mat[, grep(names(MaleExomeCount.mat), pattern = '*.bam')])

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

#save.image( sprintf("%s/male_exome_depth_count.RData", dir.output) )

for (i in 1:nsamples) {
  
          samplename <- samplenames[i + 6]
   
            print(samplename)
  #### Create the aggregate reference set for this sample
            my.choice <- select.reference.set (test.counts = ExomeCount.mat[,i],
                                     reference.counts = MaleExomeCounts.mat,
                                     bin.length = (ExomeCount.dafr$end - ExomeCount.dafr$start)/1000,
                                     n.bins.reduced = 10000)
            my.reference.selected <- apply(X = MaleExomeCounts.mat[, my.choice$reference.choice, drop = FALSE],
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
                               reference.annotation = v603_exons.GRanges,
                               min.overlap = 0.0001,
                               column.name = 'v603_exons')

  
                  output.file <- paste(dir.results, '/', args[2], '_exomedepth.csv', sep = '')
                  write.csv(file = output.file, x = all.exons@CNV.calls, row.names = FALSE)
            }
}
