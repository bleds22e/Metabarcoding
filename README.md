# Metagenomics
Repository for work on the diet partitioning study at Portal

## File Structure

### Data

#### CollectionData

Files:
* _vial_id.csv_: contains data on the vial ID code, the sample ID code (SKME_### for plants, PIT tag for rodents), and whether the sample was plant material or fecal 
* _plant_voucher_collection.csv_: data on plant vouchers collected at the Portal Project to be identified and barcoded
* _fecal_sample_collection.csv_: data for each fecal sample collected. Contains species, sex, PIT tag, sample type, and whether it was from an experiment (trap_and_bait) or not
* _Portal_plant_species.csv_: current plant list from Portal at the time. Likely needs to be updated

#### SequencedData

Insects: we ran a handful of samples to see if any insects popped out in the fecal samples, but they did not

Plants: contains both data on the DNA sequences for both plant vouchers and fecal samples

##### Processed Data

This (plus the collection data) is where the magic happens! You can likely ignore the "Old" folder. ***Bold and italicized*** files are the ones to focus on.

You'll notice that there is quite a bit of redundancy in a number of these files...I still wasn't entirely sure what I was doing when I made this repository! Lol

**ITS2 files**
By the way, ITS2 is the same as ITS.

* _ITS2_OTU_WTU_key.csv_: The key which connects OTU to WTU and taxonomic groups.
* _ITS2_OTUs.csv_: ...not sure what this is, honestly. Possibly the trnL OTU which is most associated with a given plant voucher, but I need to track this down to be sure.
* ***ITS2_reads_WeeTU.csv***: Includes the number of reads per OTU per SampleID (vialID). Includes lineage column, taxa broken into individual columns, and corresponding WTU values for each taxanomic level. Basically a combo of the OTU_WTU_key and the reads csvs.
* _ITS2_reads_with_lineage.csv_: Same as file below but includes the lineages in one column with OTUs
* _ITS2_reads.csv_: The number of reads per OTU per SampleID (vialID). Combined with the total number of reads, we can calculate the "relative read abundance" or RRA.
* ***ITS2_totals.csv***: The total number of reads for each SampleID (same as vialID). Some samples didn't amplify well and will likely need to be excluded if they have fewer than ~2000 reads.

**trnL files**

* _trnL_OTU_WTU_key.csv_: The key which connects OTU to WTU and taxonomic groups.
* _trnL_OTUs.csv_: ...not sure what this is, honestly. Possibly the trnL OTU which is most associated with a given plant voucher, but I need to track this down to be sure.
* ***trnL_reads_WeeTU.csv***: Includes the number of reads per OTU per SampleID (vialID). Includes lineage column, taxa broken into individual columns, and corresponding WTU values for each taxanomic level. Basically a combo of the OTU_WTU_key and the reads csvs.
* _trnL_reads_with_lineage.csv_: Same as file below but includes the lineages in one column with OTUs
* _trnL_reads.csv_: The number of reads per OTU per SampleID (vialID). Combined with the total number of reads, we can calculate the "relative read abundance" or RRA.
* ***trnL_totals.csv***: The total number of reads for each SampleID (same as vialID). Some samples didn't amplify well and will likely need to be excluded if they have fewer than ~2000 reads.

##### Raw Data

Hopefully you won't need to poke around in here too much! These are the original files I received from Jonah Ventures, the people who ran the DNA metabarcoding and bioinformatics.

##### Trap_Bait_Test

This data is from the test we ran with clean vs. dirty traps and traps baited with millet vs. oatmeal. I think using the Processed Data (above) and filtering out the samples which are fresh vs. trap, clean vs. dirty, millet vs. oatmeal are probably the way to go, but these might still be helpful.

* _test_ITS_fecal_data.csv_: OTU reads from fecal samples from the trap and bait test using the ITS marke
* _test_ITS_taxa_link_file.csv_: file with taxa broken out into individual columns from OTUs found during the trap and bait test for ITS marker
* _test_trnL_fecal_data.csv_: OTU reads from fecal samples from the trap and bait test using the trnL marker
* _test_ITS_voucher_data.csv_: not 100% sure what this file is. My guess is that it is data from the plant vouchers that we sent in at the same time as the trap and bait data, so I needed to separate them out from the fecal samples. Not sure why we don't have trnL voucher data...

###### figures
Plots for trap and bait data

###### scripts
Scripts for data prep and plotting the trap and bait data

###### original_data
Files as received from Jonah Ventures

## What's a WeeTU?
WeeTUs (or WTU) are the Weecology re-calculation of the OTUs (organismal taxonomic unit). DNA sequences that are identified as the same species (or other taxonomic level) can have different OTUs based on minor changes in the nucleotides. At any given taxonomic level, all of the matching identities are given the same WTU number.

For example:

* Any OTU that is idenified down to the species Muhlenbergia porteri is given the same WTU.species number: 613
* Any OTU identified to a different species of Mulhenbergia is given a unique WTU.species. Mulhenbergia richardsonis is WTU.species 614 while Mulhenbergia arenacea is WTU.species 609.
* OTUs which are identified to the genus Mulhenbergia but not identified at a species level (species = NA) are all given the same WTU.species number (618)
* Although all of the OTUs above will have different WTU.species numbers, they will all have the same WTU.genus number (and all other WTUs) because they are all identified to the same genus: WTU.genus = 395; WTU.family = 54.
* If you decide to use WTUs, I would suggest using WTU.genus for most analyses. Most of the species which are identified do not match up to species we have at our site.
