# Prep ITS2 data from Jonah Inc.
# Ellen Bledsoe
# Jan 2017

########################
# LIBRARIES

library(dplyr)

########################
# LOAD FILES

blast <- read.csv("./Plants/ITS_blast.csv", header = TRUE, na.strings = "")
no_blast <- read.csv("./Plants/ITS_no_blast.csv", header = TRUE, na.strings = "")
plants <- read.csv("./CollectionData/plant_voucher_collection.csv", header = TRUE)

########################
# CLEAN DATA

# Blast and no blast files

blast <- select(blast, -Sum)
blast <- blast[-c(463:464),]
no_blast <- select(no_blast, -Sum)

# Pull out ConsensusLineage

taxa_its <- select(blast, OTU.ID, ConsensusLineage)

for(this_level in c('k','p','c','o','f','g','s')){
  # separate taxa into columns
  step_one=sapply(strsplit(as.character(taxa_its$ConsensusLineage), paste0(this_level,'__')), '[', 2)
  step_two=sapply(strsplit(step_one, ';'), '[', 1)
  taxa_its[,this_level]=step_two
}

taxa_its <- select(taxa_its, OTU.ID, k:s) %>% 
  distinct(OTU.ID, .keep_all = TRUE) %>% 
  rename(Family = f, Genus = g, SciName = s)

#write.csv(taxa_its, "SequencedData/Plants/ITS_BLAST_taxa_link_file.csv", row.names = FALSE)

# Restructure and combine

blast <- select(blast, -ConsensusLineage)
all_ITS <- bind_rows(blast, no_blast)

all_ITS <- tidyr::gather(all_ITS, "Sample", "Reads", S008809.Wisely:S009099.Wisely) %>%
           filter(Reads != 0)
all_ITS <- tidyr::separate(all_ITS, Sample, into = c("Sample", "Wisely")) %>%
           select(-Wisely)

# vouchers dataframe

vouchers <- select(plants, vial_barcode, year) %>% 
            filter(year != '2017') %>% 
            rename(Sample = vial_barcode) %>% 
            select(-year)
vouchers_its <- semi_join(all_ITS, vouchers, by = "Sample")

#write.csv(vouchers_its, "SequencedData/Plants/ITS_voucher_data.csv", row.names = FALSE)

# fecal sample dataframe

fecal <- anti_join(all_ITS, vouchers, by = "Sample")

#write.csv(fecal, "SequencedData/Plants/ITS_fecal_data.csv", row.names = F)

########################
# UNIQUE OTUs for VOUCHERS

# best_match <- select(vouchers_its, OTU.ID, Sample, Reads, sci_name_profID) %>% group_by(Sample) %>% filter(Reads == max(Reads))
# best_match <- filter(best_match, Reads >= 1000)
# 
# length(unique(best_match$OTU.ID))
# count_OTU <- best_match %>% ungroup() %>% count(OTU.ID)


