# Goal: create new column in canada species list to represent, for every species,
# the total number of observations for the family its in
# June 2025
# Ryan Hull, Quantitative Biodiversity Lab, McGill

# loading in and processing
species <- read.csv("Canada_species_list_adapted_for_collapsibleTree.csv", sep=";")
species$observations[is.na(species$observations)] <- 0
species$observations_for_collapsibleTree_attribute <- 0 # new column to fill

for (i in 1:nrow(species)){
  
  print(i)
  
  # capturing the total observations for each family
  this_family <- species[i, "family"]
  all_family_members <- species[species$family == this_family,]
  sum_obs <- sum(all_family_members$observations)
  
  number_species <- nrow(all_family_members)
  average_obs <- sum_obs/number_species # maybe use this instead, try later?
  
  
  # assigning the total family obs for that family to each member of the family
  species[i, "observations_for_collapsibleTree_attribute"] <- sum_obs
}


# success
write.csv(species, "species_list_for_collapsibleTree_observation_coloring.csv", row.names=FALSE)
