#==========================================
# Blast_script.R
#
#   Code in this file extracts OTU sequences
#   from .fna file and runs them against
#   GenBank (or at least that's the goal)
#==========================================

################  TODO List: Description - STATUS, comments underneath

# TODO: read & extract OTUS from noblast file - DONE
# TODO: extract noblast OTU sequences from ITS .fna file - DONE
# TODO: put OTUname and sequence together in a FASTA format - DONE
# TODO: figure out how to submit those sequences to GenBank - DONE
# TODO: figure out what to do with the output - DONE
# TODO: Write script to only BLAST OTUs not already in
#       NoBlast_blastoutput.csv - DONE
# TODO: Run for the full noblast_OTUs set?
        
#######################   Main Code

library(tidyverse)
# to run this script, you will need to download bioconductor first:

setwd("/Users/bleds22e/Documents/Git/Metabarcoding")

### Reads no blast file, extracts the OTU.IDs
noblast = read.csv("./Data/SequencedData/Plants/RawData/FNA_Files/correctedOTUs_Spring2017.csv", stringsAsFactors = FALSE)
OTUs = noblast %>% dplyr::select(OTU.ID)

### Reads the .csv of the .fna file and extracts
###   only the sequences for the OTUs in the no
###   blast file

allITSseqs = read.csv("./Plants/ITS_from_fna.csv", stringsAsFactors = FALSE) 
noblast_OTUs = allITSseqs %>% filter(OTU_its %in% OTUs$OTU.ID)

### REF_SET creation
### the refset is a test set created for code development 

#OTU_refset = noblast_OTUs %>% filter(OTU_its %in% c("OTU1","OTU101", "OTU3"))

### Filter noblast OTUs 
###   Reduces the full set of noblast OTUS 
###   to just those we haven't run through BLAST yet.
###   BLAST runs can be long, so this speeds things up.

completed_blasts = read.csv("./Plants/NoBlast_blastoutput.csv", stringsAsFactors = FALSE)
completed_OTUs = unique(completed_blasts$OTU.ID)
OTUs_forBLAST = noblast_OTUs %>% filter(!(OTU_its %in% completed_OTUs))

### These packages seem to fight with dplyr, 
###   so I don't load them until I need them

#Run the two commented lines if annotate not installed yet
#BiocManager::install("annotate")
library(annotate)

### Queries BLAST
###   Pastes OTU ID and sequence together for a fasta format
###   Submits to BLAST and records output
 
file = c()
num_seq = nrow(OTUs_forBLAST)
try(if(num_seq == 0) stop("no sequences to submit", call. = FALSE))
for(i in 1:num_seq){
  print(paste("Number of sequences remaining:",num_seq-(i-1),sep=" "))
  header = as.character(paste(">",OTUs_forBLAST$OTU_its[i], sep=""))
  data = as.character(paste(header,OTUs_forBLAST$sequence_its[i],sep="\n"))
  output = blastSequences(x=data,timeout = 300,
                          hitListSize = 20, as='data.frame')
  file = rbind(file,output)
  print(paste(OTUs_forBLAST$OTU_its[i], "complete", sep = " "))
}

### Formats and Write table from BLAST
### Selects & formats only relevant columns
### Calculates Identity% & Query Coverage

names(file)[3] = 'OTU.ID'
names(file)[4] = 'Query.length'
names(file)[25] = 'Hsp.length'

clean.file = c()
clean.file = dplyr::select(file, OTU.ID, Query.length, Hit_id, Hit_def,
                           Hit_len, Hsp_evalue, 
                           Hsp_identity, Hsp.length)
clean.file = clean.file %>% mutate_each_(funs(as.integer), c("Query.length","Hit_len",
                                         "Hsp_identity","Hsp.length"))
clean.file = clean.file %>% mutate_each_(funs(as.numeric), "Hsp_evalue")
  
clean.file = clean.file %>% mutate(identity_percent = 100* (Hsp_identity/Hsp.length),
                                   Query.cover = 100* (Hsp.length/Query.length))

completed_blasts = rbind(completed_blasts,clean.file)

write.csv(completed_blasts, "./Plants/NoBlast_blastoutput.csv", row.names=FALSE)
