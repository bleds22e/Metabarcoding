# Make Trap & Bait Test plots
# June 2017

########################
# SOURCES

library(gridExtra)

setwd("~bleds22e/Documents/Git/Metagenomics")
source("./SequencedData/Trap_Bait_Test/scripts/trap_bait_test_plotting_functions.R")

reads <- read.csv("./SequencedData/Trap_Bait_Test/test_trnL_fecal_data.csv", header = T)
samples <- read.csv("./CollectionData/fecal_sample_collection.csv", header = T)
samples <- select(samples, period, Sample = vial_barcode, PIT_tag, plot, species, sample_type, notes) %>% 
  filter(period == '-460') %>% 
  tidyr::separate(notes, into = c("trap_type", "bait_type"), sep = " ")

########################
# PLOTS

### trnL ###

### rank abundance 
rank_abundance(samples, reads, cut_off = 100, bait = c('oatmeal'), trap = c('clean')) 

### by fresh and trap fecal samples
clean_millet <- fresh_vs_trap(samples, reads, bait = c('millet'), trap = c('clean'), cut_off = 250)
clean_oatmeal <- fresh_vs_trap(samples, reads, bait = c('oatmeal'), trap = c('clean'), cut_off = 250)
dirty_millet <- fresh_vs_trap(samples, reads, bait = c('millet'), trap = c('dirty'), cut_off = 250)
dirty_oatmeal <- fresh_vs_trap(samples, reads, bait = c('oatmeal'), trap = c('dirty'), cut_off = 250)
fresh_vs_trap_test <- grid.arrange(arrangeGrob(clean_millet, top = "Millet", left = "Clean"), 
                                   arrangeGrob(clean_oatmeal, top = "Oatmeal"), 
                                   arrangeGrob(dirty_millet, left = "Dirty"), 
                                   dirty_oatmeal, nrow = 2, ncol = 2)
#ggsave("./SequencedData/Trap_Bait_Test/figures/fresh_vs_trap_test.png", fresh_vs_trap_test)

### by individual animal

(clean_millet <- trap_vs_fresh_indv(samples, reads, sp = c('DM', 'DO', 'PP'), bait = c('millet'), trap = c('clean'), cut_off = 250))
#ggsave("./SequencedData/Trap_Bait_Test/figures/clean_millet_indv.png", clean_millet)

(clean_oatmeal <- trap_vs_fresh_indv(samples, reads, sp = c('DM', 'DO', 'PP'), bait = c('oatmeal'), trap = c('clean'), cut_off = 250))
#ggsave("./SequencedData/Trap_Bait_Test/figures/clean_oatmeal_indv.png", clean_oatmeal)

(dirty_millet <- trap_vs_fresh_indv(samples, reads, sp = c('DM', 'DO', 'PP'), bait = c('millet'), trap = c('dirty'), cut_off = 250))
#ggsave("./SequencedData/Trap_Bait_Test/figures/dirty_millet_indv.png", dirty_millet)

(dirty_oatmeal <- trap_vs_fresh_indv(samples, reads, sp = c('DM', 'DO', 'PP'), bait = c('oatmeal'), trap = c('dirty'), cut_off = 250))
#ggsave("./SequencedData/Trap_Bait_Test/figures/dirty_oatmeal_indv.png", dirty_oatmeal)

fresh_vs_trap_indv_test <- grid.arrange(arrangeGrob(clean_millet, top = "Millet", left = "Clean"), 
                                   arrangeGrob(clean_oatmeal, top = "Oatmeal"), 
                                   arrangeGrob(dirty_millet, left = "Dirty"), 
                                   dirty_oatmeal, nrow = 2, ncol = 2)
#ggsave("./SequencedData/Trap_Bait_Test/figures/fresh_vs_trap_indv.png", fresh_vs_trap_indv_test)
