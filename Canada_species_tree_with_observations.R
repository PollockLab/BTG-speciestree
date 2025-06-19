# Representing the entire Blitz the Gap species list as an interactive tree
# June 2025
# Ryan Hull, Quantitative Biodiversity Lab, McGill

library("collapsibleTree")
library("shiny")
library("ggplot2")
library("dplyr")
#library("shinythemes") 
#library("bslib") # to create customized theme
#library("thematic") # to apply our bslib theme to shinyApp

# loading in our master list
completeList <- read.csv("Canada_species_list_adapted_for_collapsibleTree.csv", sep=";")
completeList[completeList==0] <- NA

# Making ui to combine tree and pie charts etc for each selected node
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      collapsibleTreeOutput("tree", height="600px"),
      width=9
    ),
    mainPanel(
      plotOutput("pie"),
      downloadButton("download_filtered_df", "Download Species List"),
      width=3
    )
  )
)

server <- function(input, output, session){
  
  # tree:
  output$tree <- renderCollapsibleTree({
    collapsibleTreeSummary(
      inputId = "myTree",
      completeList,
      hierarchy= c("first_level", "second_level", "third_level", "fourth_level", "fifth_level"),
      root = "Species of Canada",
      attribute = "leafCount",
      fillFun = colorspace::heat_hcl,
      maxPercent = 25,
      percentOfParent = FALSE,
      linkLength = 150,
      fontSize = 10,
      tooltip = TRUE,
      nodeSize = NULL,
      collapsed = TRUE,
      zoomable = TRUE,
      width = NULL,
      height = NULL
    )
  })
  
  # Show pie chart when node is selected
  output$pie <- renderPlot({
    
    req(input$myTree) # so that nothing shows when u first run it
    path <- rev(input$myTree)
    cols <- c("first_level", "second_level", "third_level", "fourth_level", "fifth_level")
    
    # we need to handle the root node separately
    if (length(path) == 0) {
      df <- completeList
      
      df$obs_category <- cut(
        df$observations,
        breaks = c(-1, 0, 9, 99, 100000000),
        labels = c("0", "1–9", "10-99", ">100")
      )
      df$obs_category[is.na(df$obs_category)] <- "0"
      
      pieData <- df %>%
        count(obs_category) %>%
        arrange(desc(n))
      
      return(
        ggplot(pieData, aes(x = "", y = n, fill = obs_category)) +
          geom_bar(stat = "identity", width = 1) +
          coord_polar("y") +
          theme_void() +
          labs(
            title = "Number of observations",
            subtitle = paste("Total:", nrow(df), "species"),
            fill = NULL
          )
      )
    }
    
    # Below is for any node other than the root
    # Filter the data based on clicked path
    df <- completeList
    for (i in seq_along(path)) {
      df <- df[df[[cols[i]]] == path[[i]], ]
    }
  
    # cutting df into sections based on # observations
    df$obs_category <- cut(
      df$observations,
      breaks = c(-1, 0, 9, 99, 10000000000),
      labels = c("0", "1–9", "10-99", "100+")
    )
    # Making the NA observations 0:
    df$obs_category[is.na(df$obs_category)] <- "0" 
    
    pieData <- df %>%
      count(obs_category) %>%
      arrange(desc(n))
    
    ################ this section is for capturing the level you clicked #######
    name_of_node <- tail(path, 1)
    
    # what hierarchy level?
    hierarchy_level_clicked <- NA
    for (i in seq_along(cols)) { # for every hierarchy column
      if (name_of_node %in% completeList[[ cols[i] ]]) { # is the clicked node that column?
        hierarchy_level_clicked <- i
        break
      }
    }
      
    # Since one hierarchy level could mean many taxonomic levels, which taxonomic level at this node?
    taxonomic_level_clicked <- "Unknown" #default
    
    if (hierarchy_level_clicked == 0){
      taxonomic_level_clicked <- "" #none
      subtitle_text <- paste(name_of_node)
    }
    else if (hierarchy_level_clicked == 1){
      taxonomic_level_clicked <- "Iconic Taxon"
      subtitle_text <- paste0(taxonomic_level_clicked, ": ", name_of_node)
    }
    else if (hierarchy_level_clicked == 2){
      taxonomic_level_clicked <- unique(df$second_level_taxonomic_rank)
      subtitle_text <- paste(taxonomic_level_clicked, name_of_node)
    }
    else if (hierarchy_level_clicked == 3){
      taxonomic_level_clicked <- unique(df$third_level_taxonomic_rank)
      subtitle_text <- paste(taxonomic_level_clicked, name_of_node)
    }
    else if (hierarchy_level_clicked == 4){
      taxonomic_level_clicked <- unique(df$fourth_level_taxonomic_rank)
      subtitle_text <- paste(taxonomic_level_clicked, name_of_node)
    }
    else if (hierarchy_level_clicked == 5){
      taxonomic_level_clicked <- unique(df$fifth_level_taxonomic_rank)
      subtitle_text <- paste(taxonomic_level_clicked, name_of_node)
    }
    ######################## end of level assignment section ###################
    
    
    # assemble our subtitle for ggplot
    subtitle <- paste(
      # showing the user the taxonomic level of what node they selected
      paste(subtitle_text),
      # showing how many species under the node
      paste("Total:", nrow(df), "species"),
      sep="\n"
    )
    
    # Making the pie chart
    ggplot(pieData, aes(x = "", y = n, fill = obs_category)) +
      geom_bar(stat = "identity", width = 1) +
      coord_polar("y") +
      theme_void() +
      labs(
        title = paste("Number of observations"),
        fill = NULL,
        subtitle = subtitle,
      )
  })
  
  
  # Creating button to download all the species under selected node
  output$download_filtered_df <- downloadHandler(
    filename = function(){ # shiny apparently calls this internally
      path <- rev(input$myTree)
      name_of_node <- tail(path, 1)
      paste0("Species_of_Canada_", name_of_node, ".csv")
    },
    content = function(file) {
      path <- rev(input$myTree)
      df <- completeList
      cols <- c("first_level", "second_level", "third_level", "fourth_level", "fifth_level")
      
      for (i in seq_along(path)) {
        df <- df[df[[cols[i]]] == path[[i]], ]
      }
      
      # download only columns the user will need/understand
      df$observations[is.na(df$observations)] <- 0
      to_download = df[,c("kingdom", "phylum", "class", "order", "family", "species", "observations")]
      write.csv(to_download, file, row.names = FALSE)
    }
  )
}

# tree time
shinyApp(ui = ui, server = server)