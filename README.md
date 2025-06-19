# Interactive Taxonomic Tree of Canada's Species
Representing the entire Blitz the Gap species list as an interactive tree

Created June 2025, Ryan Hull, Quantitative Biodiversity Lab, McGill

## Goal
Visualize Canada's species taxonomically and interactively. View breakdown of species observations for every selected taxon to visualize data gaps. Download species list with observational information pulled from GBIF for every selected taxon.

## How the CSV was created and used in the shiny app
The original species list was constructed from the 2020 wild species report, adding in seaweed species through GBIF download, and running taxsize in R to add taxonomic information. Many squamates, bony fish, mollusks, others, needed help manually filling in taxonomic information. #Observations column was added by joining parquet file from iNaturalist. 

CollapsibleTree requires specific columns for each level of hierarchy displayed. Since the first level of hierarchy is by iNat iconic taxon (to increase user friendliness), this column contains levels from classes like birds to kingdoms like plants. To avoid having too many branches out of large-taxon first_level nodes like plants, we can't jump straight to order. Thus, each subsequent tree hierarchy level cannot uniquely be one taxonomic level. second_level, third_level, fourth_level, and fifth_level columns were used by collapsibleTree for hierarchy, and each hold different taxonomic levels depending on the group. **Any species additions to the csv should follow the level/taxon hierarchy for their group**.

To be able to display the taxonomic level of the node clicked, since the column name for any given node is useless (eg third_level), further columns were created (using assigning_taxonomic_levels_to_the_hierarchy_levels.R) that indicate the taxonomic level of each node clicked. The taxonomic level aswell as total species count are dynamically shown under this structure, as well as a species list for the selected group.
