# Rare Disease EWCE website and apps 
## Table of Contents
1. [EWCE Homepage ](#1)
2. [Shiny apps ](#2)
3. [Cell select app](#3)
4. [Cell select print friendly](#4)
5. [Pheno select app](#5)


## EWCE Homepage <a name = 1></a>
The HTML, CSS, and images for the webite are stored in the `EWCE_homepage_html/site1` directory. 
If you put the contents of this directory up as its own GitHub repo, you can then access the website using Github pages. 

It provides links to the interactive version of the cell select app, but I haven't included the print-friendly version (which uses the ontologyPlot package rather than ggnetwork).

I made it as separate apps linked from an HTML website because it ran very slowly when I included all the functionality in a single app. I think shiny apps preload everything, even if not currently in use. 

## Shiny apps <a name = 2></a>
### General layout
The app is executed by the `web_app.R` script. This calls the 	`source/UI.R`script, which creates the user interface, and the `source/server.R` script, which takes user inputs, does things with them, then serves back an output. 

When the user manipulates an input on the UI, it changes the value of variables stored in the `input` data structure. For example, changing the cell choice in the cell select app will change the `input$sig_pheno_plot_cell_choice` variable. These user inputs are then supplied to the server function (in `server.R`). The server function then subsets all the data and produces the figures. Most of these actions done by the server function are done by calling functions that I have made and stored in separate scripts in the source directory. 

The server then assigns the completed item to variables in the `output` data structure. For example, a plot may be assigned to `output$plot1`. Finally, we then go back to the UI and can display the plot by rendering it `renderPlot(output$plot1)` 

### Hosting the apps
There were some issues with publishing the apps because shinyserver.io is not compatible with all dependencies. The main problems were the Bioconductor versions of ontologyPlot and ontologyIndex packages. I got around this by using versions of these packages taken from the GitHub repos. Then I explicitly told the `web_app.R` script where those reports are so that the shiny-server could get the correct ones: 

```
options(repos = c(BiocManager::repositories(),
                  "https://github.com/cran/ontologyPlot",
                  "https://github.com/cran/ontologyIndex"))
```

Once a final version of the website and apps are made, it could be worth hosting all dependencies independently if they are changed or taken offline in the future. 

## Cell select app<a name = 3></a>
Most of the functions for creating the interactive plot are in `source/cell_select_ggnetwork_plot.R`. The function for getting the relative ontology level of terms within the connected components of the subset of the data to be plotted could be made more efficient. I realised that it doesn't need the adjacency matrix. Can just use the terms from the hpo$parents[hpo_id] vector. 

### Get disease descriptions from HPO
The disease descriptions for the interactive hoverplot are stored in the data directory. If more phenotypes are added in the future, the function I made to get these descriptions is here: 

```
require(httr)
require(jsonlite)

hpo_get_term_details <- function(ontologyId) {
  hpo_termdetails = GET(paste0("hpo.jax.org/api/hpo/term/", ontologyId))
  hpo_termdetails_char = rawToChar(hpo_termdetails$content)
  hpo_termdetails_data = fromJSON(hpo_termdetails_char)
  return (hpo_termdetails_data$details$definition)
}
```

It works by interacting with the HPO API, converting the output from JSON format to a list, and then returning the disease definition. 

## Cell select print friendly<a name = 4></a>
This is basically the same as the interactive version of the app. The plot is better suited to printing (as it has less overlapping, and the way it is laid out more clearly represents the ontology levels). However, this type of plot was not supported by `plotly` and could not be interactive. 

## Pheno select app<a name = 5></a>
I think the figures produced by this app could be better. Maybe use some of the functions from my report or the `ewce_plot` function from the EWCE R package. 



