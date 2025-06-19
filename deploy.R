# Script to deploy the shiny app

library(rsconnect)

# set up rsconnect
# using the blitzthegap@gmail.com account for https://www.shinyapps.io/
rsconnect::setAccountInfo(name='blitzthegap', 
                          token='7602E9D5A47AA9FCAB9E4A2CA159E83A', 
                          secret='V0ZUmxvDWZPC4v9uwiOf8VYHWj4Nmz+fq1B8OfyB')

deployApp(appTitle = "Blitz the Gap: Canadian species list")
