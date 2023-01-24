# Rare Disease Celltyping: pheno_select app
# https://neurogenomics.shinyapps.io/pheno_select

options(repos = BiocManager::repositories())  

library(shiny)
library(shinythemes)
library(plotly)
library(data.table)
library(stringr)

source("source/ui.R")
source("source/server.R")
source("source/functions.R")

#### load datasets ####
message("Loading enrichment results data.")
results <<- readRDS(file.path("data","Descartes_All_Results.rds"))

message("Loading gene annotations.")
phenotype_to_genes <<- data.table::fread(
  input = file.path("data","phenotype_to_genes.txt"),
  skip = 1,
  header = FALSE,
  col.names = c("ID", "Phenotype", "EntrezID", "Gene", 
                "Additional", "Source", "LinkID")
) 

#### Run app ####
shinyApp(ui=ui, 
         server=server)
