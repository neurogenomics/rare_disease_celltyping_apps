# Rare Disease Celltyping: pheno_select app
# https://neurogenomics.shinyapps.io/pheno_select

options(repos = BiocManager::repositories()) 

### IMPORTANT!: Must install via this method before deploying,
### NOT building your package locally in RStudio (e.g. CTRL + SHFT + B).
### See here for details: https://github.com/rstudio/rsconnect/issues/88
# devtools::install_github("neurogenomics/HPOExplorer", dependencies = TRUE)
# devtools::install_github("neurogenomics/MultiEWCE", dependencies = TRUE)

library(shiny)
library(shinythemes)
library(plotly)
library(HPOExplorer)
library(MultiEWCE)

source("source/ui.R")
source("source/server.R")
source("source/phenotype_keyword_search.R")


# load datasets (If multiple options, make this a user choice?)
message("Loading enrichment results data.")
results <<- MultiEWCE::load_example_results(file = "Descartes_All_Results.rds", 
                                            save_dir = "data") 

message("Loading gene annotations.")
phenotype_to_genes <<- HPOExplorer::load_phenotype_to_genes(
  pheno_to_genes_txt_file = file.path("data","phenotype_to_genes.txt")
)

# Run app
shinyApp(ui=ui, server=server)
