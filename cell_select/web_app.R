# Rare Disease Celltyping: cell_select app
# https://neurogenomics.shinyapps.io/cell_select
 
options(repos = BiocManager::repositories()) 

### IMPORTANT!: Must install HPOExplorer/MultiEWCE via this method before deploying,
### NOT building your package locally in RStudio (e.g. CTRL + SHFT + B).
### See here for details: https://github.com/rstudio/rsconnect/issues/88
# devtools::install_github("neurogenomics/HPOExplorer", dependencies = TRUE)
# devtools::install_github("neurogenomics/MultiEWCE", dependencies = TRUE)

library(shiny)
library(shinythemes)
library(plotly)
library(HPOExplorer)
library(MultiEWCE)

# load datasets (If multiple options, make this a user choice?)
message("Loading enrichment results data.")
results <<- MultiEWCE::load_example_results(multi_dataset = TRUE, 
                                            save_dir = "data")   
# results <- MultiEWCE::map_celltype(results)

message("Loading HPO.")
hpo <<- HPOExplorer::get_hpo(save_dir = "data") 

source("source/ui.R")
source("source/server.R") 
celltypes <- unique(results[q <= 0.05,]$CellType)
celltypes <<- sort(as.character(celltypes))

# Run app
shiny::shinyApp(ui = ui, 
                server = server)
