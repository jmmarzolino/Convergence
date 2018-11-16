# Work to divide the downloaded, freshly sequenced FASTQ files for the convergent evolution project, into barcode divided files (files based on pooled sampled generation)

# unzip the files so you can read them
cd /rhome/jmarz001/shared/SEQ_RUNS/10_17_2018/FASTQ/
gunzip Jill*.gz
cp Jill*.fastq /rhome/jmarz001/bigdata/convergent_evolution/data/
cd /rhome/jmarz001/bigdata/convergent_evolution/data/
# get nreads for demultiplex function
grep -c "@" {Jill-1_S3_R1_001.fastq,Jill-2_S4_R1_001.fastq} >> ../fastq_lines
#Jill-1 33960791
#Jill-2 45169644
# barcodes are manually written into 'con_barcodes' file
/rhome/jmarz001/bigdata/convergent_evolution/barcodes/con_barcodes


## Now working in R
# Put the following in an R script and package within a bash script to run the R script
(Rsub.sh)
#!/bin/bash -l

#SBATCH --output=/rhome/jmarz001/bigdata/convergent_evolution/scripts/div.stdout
#SBATCH --job-name='division'
#SBATCH -p koeniglab
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=32G
#SBATCH --time=24:00:00

Rscript /rhome/jmarz001/bigdata/convergent_evolution/scripts/div.R


(div.R)
#!/usr/bin/env R

# load necessary package
library("systemPipeR", lib.loc="/bigdata/operations/pkgadmin/opt/linux/centos/7.x/x86_64/pkgs/R/3.5.0/lib64/R/library")
# define the demultiplex function in R
demultiplex <- function(x, barcode, nreads) { #create a function that takes four arguments
	f <- FastqStreamer(x, nreads) #splits the fastq sequence into its reads
	while(length(fq <- yield(f))) { #do the following for every item in the vector (for every read)
		for(i in barcode) { #from first to last barcode do the following
			pattern <- paste("^", i, sep="") #paste a new line symbol and the barcode sequence, with each entry separated by "", into an element called pattern
			fqsub <- fq[grepl(pattern, sread(fq))] #search for the pattern created in fq, take those sequences of fq and supply them to another element, fqsub (the useful subset of fq)
			if(length(fqsub) > 0) { #using only elements which exist, ie. are non-zero
				writeFastq(fqsub, paste(x, i, sep="_"), mode="a", compress=FALSE) #write a FASTQ file with fqsub sequences, original sequences and i in barcode seaparated by ""
			}
		}
	}
	close(f)
}

# barcodes are manually written into
y <- "/rhome/jmarz001/bigdata/convergent_evolution/barcodes/con_barcodes"

# run the function on your two files
x <- "/rhome/jmarz001/bigdata/convergent_evolution/data/Jill-1_S3_R1_001.fastq"
# separate pooled read sequences by barcode
demultiplex(x=x, barcode=y, nreads=33960791)

x <- "/rhome/jmarz001/bigdata/convergent_evolution/data/Jill-2_S4_R1_001.fastq"
demultiplex(x=x, barcode=y, nreads=45169644)