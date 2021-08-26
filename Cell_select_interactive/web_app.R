# EWCE Rare Disease Web App
# https://ovrhuman.shinyapps.io/Cell_select_ggnetwork/

# Downloading the package from github seems to have fixed the dependencies problem
# May be worth forking the two packages to create a stable version?
options(repos = c(BiocManager::repositories(),
                  "https://github.com/cran/ontologyPlot",
                  "https://github.com/cran/ontologyIndex"))

#install.packages("devtools")

#library(devtools)
# dependencies

#install_github("cran/ontologyPlot")
#install_github("cran/ontologyIndex")

library(ggnetwork)
library(ggplot2)
library(viridis)
library(network)
require(plyr)
require(reshape2)
library(shiny)
library(shinythemes)
library(plotly)
library(DT)
require(graph)
require(Rgraphviz)
require(ontologyIndex)
require(ontologyPlot)
require(stringr)
require(cowplot)
source("source/ui.R")
source("source/server.R")
source("source/signif_enrichments_for_cell.R")
source("source/cell_select_ggnetwork_plot.R")

# load datasets (If multiple options, make this a user choice?)
message("Loading results data.")
all_results_merged <- readRDS("data/Descartes_All_Results.rds")
phenotype_to_genes = data.table::fread("data/phenotype_to_genes.txt", 
                                       skip = 1, header=FALSE, 
                                       col.names =  c("ID", "Phenotype", "EntrezID", "Gene",
                                                      "Additional", "Source", "LinkID"))
message("Loading results HPO.")
data(hpo)
disease_descriptions = readRDS("data/disease_descriptions.rds")
rownames(disease_descriptions) = disease_descriptions$HPO_id

# Run app
shinyApp(ui=ui,server=server)
