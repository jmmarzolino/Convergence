# Convergence  

### FASTQ Location  
/rhome/jmarz001/shared/SEQ_RUNS/10_8_2018/FASTQ/  

#### File Names
UCRKL000010   CCV Davis F25   
10_S226_L003_R1_001.fastq.gz      
10_S226_L003_R2_001.fastq.gz      
10_S226_L004_R1_001.fastq.gz      
10_S226_L004_R2_001.fastq.gz      

UCRKL000016   CCV Davis F42  
16_S227_L003_R1_001.fastq.gz       
16_S227_L003_R2_001.fastq.gz  
16_S227_L004_R1_001.fastq.gz  
16_S227_L004_R2_001.fastq.gz  

UCRKL000024   CCXXI Davis F25   
24_S228_L003_R1_001.fastq.gz     
24_S228_L003_R2_001.fastq.gz  
24_S228_L004_R1_001.fastq.gz  
24_S228_L004_R2_001.fastq.gz  

UCRKL000250   CCII Boz  F27  
250_S229_L003_R1_001.fastq.gz     
250_S229_L003_R2_001.fastq.gz  
250_S229_L004_R1_001.fastq.gz  
250_S229_L004_R2_001.fastq.gz  

UCRKL000255   CCII Boz  F50  
255_S230_L003_R1_001.fastq.gz     
255_S230_L003_R2_001.fastq.gz  
255_S230_L004_R1_001.fastq.gz  
255_S230_L004_R2_001.fastq.gz  

UCRKL000257   CCV Davis F6  
257_S231_L003_R1_001.fastq.gz    
257_S231_L003_R2_001.fastq.gz  
257_S231_L004_R1_001.fastq.gz  
257_S231_L004_R2_001.fastq.gz  

UCRKL000258   CCV Boz F6  
258_S232_L003_R1_001.fastq.gz    
258_S232_L003_R2_001.fastq.gz  
258_S232_L004_R1_001.fastq.gz  
258_S232_L004_R2_001.fastq.gz  

UCRKL000262   CCV Boz F25  
262_S233_L003_R1_001.fastq.gz    
262_S233_L003_R2_001.fastq.gz  
262_S233_L004_R1_001.fastq.gz  
262_S233_L004_R2_001.fastq.gz  

UCRKL000267   CCXXI Davis F11  
267_S234_L003_R1_001.fastq.gz    
267_S234_L003_R2_001.fastq.gz  
267_S234_L004_R1_001.fastq.gz  
267_S234_L004_R2_001.fastq.gz  
  
### Scripts  
  
#### barcode.py  
attempt to split the fastq files by barcode, uncertain if it works
  
#### prep.sh  
move the files from their SEQ_RUN storage into the project data directory and unzip them  

#### fq.seqs.sh  
count the number of reads in each unzipped fastq file  
  in future, would like to add lines to add reads together per population and per sequencing lane (for now done manually)  

#### fastq_qc.sh  
generate fastqc (quality) data from the raw fastq files, store them in the fastqc directory  
#### unzip.sh  
unzips the fastq-fastqc files so the files are put in a directory and you can access the quality, etc.  
  
#### trim.sh  
trim the reads based on length, quality, sliding window &etc.  

#### trim.seqs.sh  
count the number of reads in each trimmed file  
  in future, should add code to print retained reads (print reads in trimmed files, intake fq.seq.sh reads, and divide to produce percent retained reads)   

#### trim_qc.sh  
generate fastqc data from trimmed fastq files, stored in subdirectory of fastqc dir  

#### align_and_group.sh  
align to chromosome split whole genome fasta and assign read groups based on population and lane  
sort bams and make unmapped files, etc  

#### dupfree.sh  
mark duplicates in the bam files  

#### snp_caller.sh  
call snps with freebayes with split genome sections indicated for speed,  
feed in all files so that snp calls are more accurate, output one vcf file  
population info can still be used because of read group labels

#### filter.sh  
filter called snps based on:  
quality distribution, missing data distribution, % homozygous and heterozygous, depth & heterozygosity, minor allele frequency, allele balance, allele observations, and haplotype variant calls according to proximity  
