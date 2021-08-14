# EWCE Rare Disease Web App
# https://ovrhuman.shinyapps.io/EWCE_App/

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


# load datasets (If multiple options, make this a user choice?)
load("data/Descartes_All_Results.rda")
phenotype_to_genes = read.delim("data/phenotype_to_genes.txt", skip = 1, header=FALSE)
colnames(phenotype_to_genes) = c("ID", "Phenotype", "EntrezID", "Gene",
                                 "Additional", "Source", "LinkID")
data(hpo)

# Run app
shinyApp(ui=ui,server=server)
