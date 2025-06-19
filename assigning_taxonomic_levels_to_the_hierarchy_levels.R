# Goal: since the different columns for levels used to construct the collapsible tree
# represent different taxonomic groups based on what group of species you're exploring,
# and since we want to display the taxonomic level, we need to have separate columns
# idenfifying what taxonomic-level each collapsibleTree-level represents for each row

# June 2025
# Ryan Hull

# Loading
rm(list=ls())
species <- read.csv("all_species_adapted_for_tree_with_observations.csv",sep=";")
species[is.na(species)] <- 0 # to make all NA/0 values uniform, displayed as 0.
species[species == ""] <- 0 # ditto

for (i in 1:nrow(species)){
  # keep track of how far we've gotten
  print(i)
  
  # collapsible tree levels
  second_level <- species[i, "second_level"]
  third_level <- species[i, "third_level"]
  fourth_level <- species[i, "fourth_level"]
  fifth_level <- species[i, "fifth_level"]
  
  # taxonomic levels
  phylum <- species[i, "phylum"]
  class <- species[i, "class"]
  order <- species[i, "order"]
  family <- species[i, "family"]
  
  # assigning the tax. levels to the second level in new column
  if (second_level == 0){
    species[i, "second_level_taxonomic_rank"] <- NA
  }
  else if (second_level == phylum){
    species[i, "second_level_taxonomic_rank"] <- "Phylum"
  }
  else if (second_level == class){
    species[i, "second_level_taxonomic_rank"] <- "Class"
  }
  else if (second_level == order){
    species[i, "second_level_taxonomic_rank"] <- "Order"
  }
  else if (second_level == family){
    species[i, "second_level_taxonomic_rank"] <- "Family"
  }
  else{
    # This should never happen
    print("something went wrong at this row")
    break
  }
  
  
  # assigning the tax. levels to the third level in new column
  if (third_level == 0){
    species[i, "third_level_taxonomic_rank"] <- NA
  }
  else if (third_level == phylum){
    species[i, "third_level_taxonomic_rank"] <- "Phylum"
  }
  else if (third_level == class){
    species[i, "third_level_taxonomic_rank"] <- "Class"
  }
  else if (third_level == order){
    species[i, "third_level_taxonomic_rank"] <- "Order"
  }
  else if (third_level == family){
    species[i, "third_level_taxonomic_rank"] <- "Family"
  }
  else{
    # This should never happen
    print("something went wrong at this row")
    break
  }
  
  
  
  # assigning the tax. levels to the fourth level in new column
  if (fourth_level == 0){
    species[i, "fourth_level_taxonomic_rank"] <- NA
  }
  else if (fourth_level == phylum){
    species[i, "fourth_level_taxonomic_rank"] <- "Phylum"
  }
  else if (fourth_level == class){
    species[i, "fourth_level_taxonomic_rank"] <- "Class"
  }
  else if (fourth_level == order){
    species[i, "fourth_level_taxonomic_rank"] <- "Order"
  }
  else if (fourth_level == family){
    species[i, "fourth_level_taxonomic_rank"] <- "Family"
  }
  else{
    # This should never happen
    print("something went wrong at this row")
    break
  }
  
  
  # assigning the tax. levels to the fifth level in new column
  if (fifth_level == 0){
    species[i, "fifth_level_taxonomic_rank"] <- NA
  }
  else if (fifth_level == phylum){
    species[i, "fifth_level_taxonomic_rank"] <- "Phylum"
  }
  else if (fifth_level == class){
    species[i, "fifth_level_taxonomic_rank"] <- "Class"
  }
  else if (fifth_level == order){
    species[i, "fifth_level_taxonomic_rank"] <- "Order"
  }
  else if (fifth_level == family){
    species[i, "fifth_level_taxonomic_rank"] <- "Family"
  }
  else{
    # This should never happen
    print("something went wrong at this row")
    break
  }
}


# success
write.csv(species, "tree_adapted_list_with_observations_and_taxa.csv", row.names=FALSE)
