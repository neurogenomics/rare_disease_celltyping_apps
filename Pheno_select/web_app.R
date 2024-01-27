# Rare Disease Celltyping: pheno_select app
# https://neurogenomics.shinyapps.io/pheno_select

options(repos = BiocManager::repositories())  

library(shiny)
library(shinythemes)
library(plotly)
library(stringr)
library(HPOExplorer)
library(MultiEWCE)

### IMPORTANT!: Must install HPOExplorer/MultiEWCE via this method before deploying,
### NOT building your package locally in RStudio (e.g. CTRL + SHFT + B).
### See here for details: https://github.com/rstudio/rsconnect/issues/88
# devtools::install_github("neurogenomics/HPOExplorer", dependencies = TRUE)
# devtools::install_github("neurogenomics/MultiEWCE", dependencies = TRUE)

source("source/ui.R")
source("source/server.R")
source("source/functions.R")

#### load datasets ####
message("Loading enrichment results data.")
results <<- MultiEWCE::load_example_results(multi_dataset = TRUE, 
                                            save_dir = "data")


#### Run app ####
shinyApp(ui=ui, 
         server=server)
