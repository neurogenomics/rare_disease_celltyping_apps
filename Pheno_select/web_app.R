# EWCE Rare Disease Web App
# https://ovrhuman.shinyapps.io/EWCE_App/

# Downloading the package from github seems to have fixed the dependencies problem
# May be worth forking the two packages to create a stable version?
# options(repos = c(BiocManager::repositories(),
#                   "https://github.com/cran/ontologyPlot",
#                   "https://github.com/cran/ontologyIndex"))
options(repos = BiocManager::repositories())
#install.packages("remotes")

# library(remotes)
# dependencies

# remotes::install_github("cran/ontologyPlot")
# remotes::install_github("cran/ontologyIndex")

# require(reshape2)
# require(scales)
require(ggplot2)
# require(plyr)
library(shiny)
library(shinythemes)
# library(plotly)
# library(DT)
# require(stringr)
# require(cowplot)
source("source/ui.R")
source("source/server.R")
source("source/phenotype_keyword_search.R")


# load datasets (If multiple options, make this a user choice?)
all_results_merged <- readRDS("data/Descartes_All_Results.rds")
phenotype_to_genes = data.table::fread("data/phenotype_to_genes.txt", 
                                       skip = 1, header=FALSE,
                                       col.names = c("ID", "Phenotype", "EntrezID", "Gene",
                                                     "Additional", "Source", "LinkID"))

# Run app
shinyApp(ui=ui,server=server)
